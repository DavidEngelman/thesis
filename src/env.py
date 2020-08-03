import collections
import copy
import os
import random
import re
import time
import timeit
import subprocess
import resource
from pathlib import Path
import paramiko
from scp import SCPClient

import gym
# import llvmlite.binding as llvm
# import llvmlite.ir as ll
import numpy as np
from gym import spaces

from .utils import *
from .parse_llvm import LLVMParser

NB_RUNS = 10


class LLVMEnv(gym.Env):

    def __init__(self, file_path, timer, onehot=False, reward_scaler=1e6, op_age=min, save_ll=False, remote=False,
                 with_age=True, ip_address=None, h_size=2):
        super(LLVMEnv, self).__init__()

        self.file_path = file_path

        self.reward_scaler = reward_scaler
        self.timer = timer
        self.extremum = op_age
        self.onehot = onehot
        self.MAX_AGE = 10
        self.save_ll = save_ll
        self.with_age = with_age
        self.ssh_con = False
        self.scp_con = False
        self.ip_address = None
        self.h_size = h_size  # size of the history

        # configure ssh connection to raspberryPi
        if remote:
            self.ip_address = ip_address
            self.ssh_con = paramiko.SSHClient()
            self.ssh_con.load_system_host_keys()
            self.ssh_con.connect(self.ip_address, username="ubuntu", password="qwertyuiop")
            self.scp_con = SCPClient(self.ssh_con.get_transport())

        # instructions handle by the environment
        self.instr_to_opcode = {
            "call": 1,
            "tail": 1,
            "store": 2,
            "load": 3,
            "fadd": 4,
            "fsub": 5,
            "fmul": 6,
            "fdiv": 7,
            "bitcast": 8,
            "fpext": 9,
            "sitofp": 10,
            "fptrunc": 11,
            "other": 12
        }

        # self.instr_to_opcode = {
        #     "alloca": 1,
        #     "alloca": 1,
        #     "store": 2,
        #     "load": 3,
        #     "fpext": 4,
        #     "fmul": 5,
        #     "fdiv": 6,
        #     "sitofp": 7,
        #     "other": 8
        # }

        self.max_step = 50000
        self.curr_step = 0

        # Define action and state spaces

        # 2 actions: choose instruction or not.
        self.action_space = spaces.Discrete(2)
        if not self.onehot:
            if self.with_age:
                self.observation_space = spaces.Box(low=np.array([0, 0, 0, 0, 1]),
                                                    high=np.array([12, 12, 12, self.MAX_AGE, 4]),
                                                    dtype=int)
            else:
                self.observation_space = spaces.Box(low=np.array([0, 0, 0, 0]),
                                                    high=np.array([12, 12, 12, 4]),
                                                    dtype=int)

        else:
            if self.with_age:
                low = np.concatenate((
                    np.array([0] * (self.h_size + 1) * len(self.instr_to_opcode)),
                    np.array([0] * (self.MAX_AGE + 1)),
                    np.array([0] * 4)
                ))

                high = np.concatenate((
                    np.array([1] * (self.h_size + 1) * len(self.instr_to_opcode)),
                    np.array([1] * (self.MAX_AGE + 1)),
                    np.array([1] * 4)
                ))
            else:
                low = np.concatenate((
                    np.array([0] * (self.h_size + 1) * (len(self.instr_to_opcode))),
                    np.array([0] * 4)
                ))
                high = np.concatenate((
                    np.array([1] * (self.h_size + 1) * (len(self.instr_to_opcode))),
                    np.array([1] * 4)
                ))

            self.observation_space = spaces.Box(low=low, high=high, dtype=int)

        self.selected_instruction = None  # current selected instruction
        self.schedulable_instructions = None

        # last  scheduled instructions's opcode
        self.history = collections.deque([0] * (self.h_size), self.h_size)

        self.llvm = LLVMController(self.file_path)

        print("timing original file")
        self.original_time = self.llvm.run(self.timer, self.curr_step, False, self.ssh_con, self.scp_con,
                                           self.ip_address, time_original=True)
        print(f"original program time is: {self.original_time}s")

    def add_instruction(self):
        """
        Add an instruction to the program in construction
        """
        self.llvm.curr_instr_graph.remove_node(self.selected_instruction)

        self.llvm.scheduled_instructions.append(self.selected_instruction)
        # update the schedulable instruction list
        self.schedulable_instructions, reset_history = self.llvm.find_schedulable_instructions()
        self.history.append(self.to_opcode(self.selected_instruction))
        if reset_history:
            self.history = collections.deque([0] * (self.h_size), self.h_size)

    def step(self, action):

        """
        One step of the environment.
        it performs the action chosen by the rl agent
        :param action:
        :return:
        """

        self.curr_step += 1
        # if max step is reached
        if self.curr_step > self.max_step:
            done = True
            next_state = None
            reward = 0
            return next_state, reward, done, {}

        self.nb_shedulables.append(len(self.schedulable_instructions))

        # if the agent has chosen to schedule the instruction
        if action == 0 or self.selected_instruction.seen_count > 3:
            self.add_instruction()

        done = len(self.schedulable_instructions) == 0

        if done:
            next_state = None

            self.run_time = self.llvm.run(self.timer, self.curr_step, False, self.ssh_con, self.scp_con,
                                          self.ip_address)
            min_rt = self.run_time[0]
            mean_rt = self.run_time[1]

            original_min_rt = self.original_time[0]
            original_mean_rt = self.original_time[1]

            print(self.run_time)
            reward = ((original_min_rt - min_rt) / original_min_rt) * 10

            print(f"Reward {reward}")
            print(f"nb_steps {self.curr_step}")
            print(f"Runtime {self.run_time}")

        else:
            reward = 0
            next_instruction_opcode = self.select_next_instruction(self.schedulable_instructions)
            next_state = self.update_state()

        return next_state, reward, done, {"episode": {"run_time": self.run_time, "r": reward, "l": self.curr_step}}

    def update_state(self):
        """build the state that will be shown to the agent based on the action it has chosen """
        state = list()
        not_encoded = list()

        #1- add the history (i.e the last instructions placed in the program
        state.extend(self.history)
        state.extend([self.to_opcode(self.selected_instruction)])

        not_encoded.extend(self.history)
        not_encoded.extend([self.to_opcode(self.selected_instruction)])
        #2- onehot encode the history
        state = self.oneHotInstructions(state)
        #3- add the age of the operands
        if self.with_age:
            operands_ages = self.compute_operands_ages()
            not_encoded.append(operands_ages)
            operands_ages = self.oneHotAge(operands_ages)
            state.extend(operands_ages)

        not_encoded.append(self.selected_instruction.seen_count)
        assert (1 <= self.selected_instruction.seen_count <= 4)
        #3- add the seen counter into the state
        seen_counter = self.oneHotSeenCounter(self.selected_instruction.seen_count)
        state.extend(seen_counter)
        print(f"current_instruction = {self.selected_instruction.str_repr}")
        print(f"not encoded: {not_encoded}")
        print(f"encoded: {state}")
        # print(len(state))
        return np.array(state) if self.onehot else np.array(not_encoded)

    def oneHotInstructions(self, state):
        encoded_states = np.array([])
        for elem in state:
            encoded = np.zeros(len(self.instr_to_opcode))
            encoded[elem] = 1
            encoded_states = np.append(encoded_states, encoded)
        return list(encoded_states)

    def oneHotAge(self, age):
        encoded = np.zeros(self.MAX_AGE + 1)
        encoded[age] = 1
        return list(encoded)

    def oneHotSeenCounter(self, seen_counter):
        encoded = np.zeros(4)
        encoded[seen_counter - 1] = 1
        return list(encoded)

    def select_next_instruction(self, instructions):
        """
        Chooses 1 instruction among the schedulables ones to be proposed to the agent
        update the selected_instruction attribute and return the opcode of the instruction
        """
        self.selected_instruction = random.choice(instructions)
        instruction_opcode = self.to_opcode(self.selected_instruction)

        self.selected_instruction.seen_count += 1
        return instruction_opcode

    def to_opcode(self, instruction):
        """
        Converts the instruction to its opcode
        """
        if not instruction.opcode in self.instr_to_opcode:
            opcode = self.instr_to_opcode["other"]
        else:
            opcode = self.instr_to_opcode[instruction.opcode]
        return opcode

    def compute_operands_ages(self):
        """
        max/min (depending on extremum) age of the current instruction's operands.
        The age of an operand is defined as the number of instructions between
        itself and the current instruction. The max age is 10
        """
        ages = []
        for op in self.selected_instruction.operands:
            if op not in self.llvm.scheduled_instructions:
                op_age = 0
            else:
                op_age = len(self.llvm.scheduled_instructions) - \
                         self.llvm.scheduled_instructions.index(op)  # current op age
            ages.append(op_age)

        if len(ages) == 0:
            res = 0
        else:
            res = self.extremum(ages)

        return min(res, self.MAX_AGE)  # res bounded between 0 and 10

    def render(self):
        """
        Useful for debugging
        """
        print("---ENV---")
        print("Last 4 Instructions Scheduled({}):".format(len(self.llvm.scheduled_instructions)))
        for instr in self.llvm.scheduled_instructions[-4:]:
            print(instr)
        print("Schedulable Instructions:")
        for instr in self.llvm.schedulable_instructions:
            print(instr)
        print('------')

    def reset(self):
        self.curr_step = 0
        self.run_time = None
        self.llvm.reset()
        self.selected_instruction = None
        self.schedulable_instructions = None
        self.history = collections.deque([0] * (self.h_size), self.h_size)
        self.schedulable_instructions, _ = self.llvm.find_schedulable_instructions()
        self.nb_shedulables = []
        next_instruction_opcode = self.select_next_instruction(self.schedulable_instructions)
        next_state = self.update_state()

        return next_state


class LLVMController:

    def __init__(self, file_path):
        with open(file_path, 'r') as file:
            data = file.read()

        self.file_path = file_path
        self.mod = LLVMParser.parse(self.file_path)
        self.functions = self.mod.functions
        self.llvm_code = self.get_llvm_code()
        self.original_file = data
        self.string_file = copy.deepcopy(self.original_file)

        self.instr_graphs = self.create_all_graphs()

        self.curr_function = 0
        self.curr_block = 0

        self.reordered_blocks = []  # blocks of a function with new order of instructions
        self.curr_llvm_code = copy.deepcopy(self.llvm_code)

        self.block_instructions = []
        self.scheduled_instructions = []
        self.schedulable_instructions = []

        self.curr_instr_graph = None
        self.curr_memory_graph = None

        self.function_start = 0
        self.index_file_start = 0

        self.avg_sched_per_bloc = 0

    def get_llvm_code(self):
        """store all the code in an array"""
        llvm_code = []
        for func in self.mod.functions:
            for block in func.blocks:
                for instruction in block.instructions:
                    llvm_code.append(instruction.str_repr)
        return llvm_code

    def create_all_graphs(self):
        """create de instructions dependency and memory dependency graphs for all blocks"""

        print("[env]: creating all memory and instruction graphs... ")

        all_instr_graphs = []
        for function in self.mod.functions:
            function_instr_graph = []
            for block in function.blocks:
                instr_graph = create_dependency_graphs(block.instructions)
                function_instr_graph.append(instr_graph)

            all_instr_graphs.append(function_instr_graph)

        return all_instr_graphs

    def get_block_instructions(self):
        """
        Gets the current block of instructions
        """
        return self.functions[self.curr_function].blocks[self.curr_block]

    def init_new_block(self):
        """
        Resets all the needed variables at the beginning of a new block
        """
        self.avg_sched_per_bloc = 0
        self.new_block = True
        self.scheduled_instructions = []
        self.block_instructions = self.get_block_instructions()
        self.terminal_instr = self.block_instructions[-1]
        self.curr_instr_graph = self.instr_graphs[self.curr_function][self.curr_block].copy()

    def update_counters(self):
        self.curr_block += 1
        # check if a function is done
        if self.curr_block == len(self.functions[self.curr_function]):
            self.write_reordered_function()
            self.curr_block = 0
            self.curr_function += 1
            self.reordered_blocks = []

    def find_schedulable_instructions(self):
        '''
        Return a list of shedulable instructions to show to the agent.
        Additionaly, return a bool to indicate if the history has to be reset (when a new block start)
        '''
        reinit_history = False  # wether the env has to reinit the history (if a new block start)
        while len(self.scheduled_instructions) == (len(self.block_instructions)):
            self.reordered_blocks.append(self.scheduled_instructions)
            self.update_counters()
            if self.curr_function < len(self.functions):
                self.init_new_block()
                reinit_history = True
            else:
                return [], reinit_history

        self.schedulable_instructions = []

        for instruction in list(self.curr_instr_graph.nodes()):
            if self.is_schedulable(instruction):
                self.schedulable_instructions.append(instruction)

        self.check_schedulables()

        return self.schedulable_instructions, reinit_history

    def is_schedulable(self, instruction):
        if self.curr_instr_graph.in_degree(instruction) != 0:
            return False
        return True

    def check_schedulables(self):
        """
        if phi in schedulable instr: remove all others from schedulable list
        if terminal instr in schedulable list and not the only one schedulabe, remove it.
        so that phi instr will always remains a the top of a block, terminal instr at the end.
        """

        # check if phi and terminal instruction in schedulable instructions
        for instr in self.schedulable_instructions:
            if instr.opcode == "phi":
                self.schedulable_instructions = [instr]
                return

        # terminal instr only schedulable if its the only one schedulable
        if self.terminal_instr in self.schedulable_instructions and len(self.schedulable_instructions) != 1:
            self.schedulable_instructions.remove(self.terminal_instr)

    def write_reordered_function(self):
        """
        Recreates a valid llvm function from a sequence of instruction
        """
        replaced_block = []
        for i, b in enumerate(self.functions[self.curr_function]):
            block_first_instruction = b[0].str_repr
            block_last_instruction = b[-1].str_repr

            to_replace = [reformat_string(inst.str_repr) for inst in self.reordered_blocks[i]]
            replaced_block.extend(to_replace)

            string_start = self.original_file.index(block_first_instruction, self.index_file_start)
            string_end = self.original_file.index(block_last_instruction, string_start) + len(
                block_last_instruction) - 1
            self.index_file_start = string_end

            new_string = list_to_string(to_replace)
            self.string_file = self.string_file.replace(
                self.original_file[string_start:string_end + 1],
                new_string.rstrip()
            )

        # current function first block first instruction
        function_first_instruction = self.reordered_blocks[0][0].str_repr
        # current function last block last instruction
        function_last_instruction = self.reordered_blocks[-1][-1].str_repr
        function_start_index = self.string_file.index(function_first_instruction, self.function_start)

        function_end_index = self.string_file.index(function_last_instruction, function_start_index) + len(
            function_last_instruction) - 1
        self.function_start = function_end_index

        self.rename_variables(function_start_index, function_end_index, replaced_block)

    def rename_variables(self, start, end, replaced_block):
        """rename the name of a basic block variables to be valid"""
        names = []
        to_ignore = []

        for line in replaced_block:
            if len(line.strip()) != 0 and line.strip()[0] == "%":
                var_name = line.strip().split(" ")[0][1:]
                try:
                    names.append(int(var_name))
                except ValueError:
                    to_ignore.append(var_name)
            names.sort()
        i = 0

        new_string = self.string_file[start:end + 1]

        for line in replaced_block:
            if len(line.strip()) != 0 and line.strip()[0] == "%":
                real_instr_num = line.strip().split(" ")[0][1:]
                if real_instr_num in to_ignore:
                    print(real_instr_num)
                    continue

                regex = rf"%{real_instr_num}\b"
                new_string = re.sub(regex, f"§{names[i]}", new_string)
                i += 1

        new_string = new_string.replace("§", '%')

        self.string_file = self.string_file.replace(
            self.string_file[start:end + 1],
            new_string
        )

    def reset(self):

        self.curr_llvm_code = copy.deepcopy(self.llvm_code)
        self.string_file = copy.deepcopy(self.original_file)
        self.reset_graphs()
        self.curr_block = 0
        self.curr_function = 0
        self.reordered_blocks = []
        self.schedulable_instructions = []
        self.init_new_block()
        self.function_start = 0
        self.index_file_start = 0

    def reset_graphs(self):
        for f in self.instr_graphs:
            for g in f:
                for node in g:
                    node.seen_count = 0

    def run(self, timer, step, save=False, ssh_con=False, scp_con=None, ip_address=None, time_original=False):
        print("[env]: running code for evalution...")
        # create llvm file
        print(self.string_file == self.original_file)
        with open("llvm_file.ll", "w") as text_file:
            text_file.write(self.string_file)
        # compile it using clang
        if not ssh_con:
            # compile it using clang
            if time_original:
                subprocess.run(["clang-9",
                                "-O0",
                                "-o", "res",
                                self.file_path,
                                "-march=native",
                                "-mllvm", "-enable-misched=false",
                                "-mllvm", "-enable-post-misched=false",
                                "-lm",
                                ])
            else:
                subprocess.run(["clang-9",
                                "-O0",
                                "-o", "res",
                                "llvm_file.ll",
                                # self.file_path,
                                "-march=native",
                                "-mllvm", "-enable-misched=false",
                                "-mllvm", "-enable-post-misched=false",
                                "-lm",
                                ])
            # time program
            times = []
            # select only one cpu
            pid = os.getpid()
            os.sched_setaffinity(pid, {0})
            for _ in range(1):
                #     usage_start = resource.getrusage(resource.RUSAGE_CHILDREN)
                #     # subprocess.run(["./res"])
                #     subprocess.run(["./res"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
                #     usage_end = resource.getrusage(resource.RUSAGE_CHILDREN)
                #     times.append(usage_end.ru_utime - usage_start.ru_utime)
                p = subprocess.run(
                    ["sshpass", "-p", "mamouche97", "sudo", "perf", "stat", "-r", str(NB_RUNS), "-o", "data.txt",
                     "./res"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
                with open("data.txt", "r") as f:
                    res = f.readlines()
                res = res[9]
                res = res.strip().split(" ")
                res = res[0]
                res = res.replace(",", "")
                times.append(float(res))

            os.sched_setaffinity(pid, {0, 1, 2, 3})

            # output_ok = are_equals("reference", "rendered_scene")
            # print(f"output image correct : {output_ok}")
            # if not are_equals("reference", "rendered_scene"):
            #     print("program output problem")
            #     exit()
            # if save:
            #     print("[env]: dumping files")
            #     Path("saved/").mkdir(parents=True, exist_ok=True)
            #     with open(f"saved/dumpll_{step}.ll", "w") as text_file:
            #         text_file.write(self.string_file)

            #     subprocess.run(["cp",  "res",  f"saved/dumpexec_{step}"])

            times = times[1:]
            # return min(times), np.mean(times), np.std(times)
            return float(res), float(res), float(res)
        # remote
        else:
            original_file = self.file_path.split("/")[-1]
            if time_original:
                to_compile = original_file
            else:
                to_compile = "llvm_file.ll"

            # send file to rpi
            if not time_original:
                scp_con.put(to_compile, f"/home/ubuntu/")
                subprocess.run(["sshpass", "-p", "qwertyuiop", "scp", "-4", to_compile, f"ubuntu@{str(ip_address)}:/home/ubuntu/"])

            ssh_con.exec_command("cd thesis", get_pty=True)
            _, ssh_stdout, _ = ssh_con.exec_command(f"python3 thesis/time_rpi_perf.py {to_compile}", get_pty=True)

            for line in iter(ssh_stdout.readline, ""):
                print(line, end="")
            line = line.split(",")
            line = tuple([float(elem) for elem in line])
            return line
