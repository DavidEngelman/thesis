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

import gym
import llvmlite.binding as llvm
import llvmlite.ir as ll
import numpy as np
from gym import spaces


from .utils import * 
from .parse_llvm import LLVMParser

NB_RUNS = 30



class LLVMEnv(gym.Env):

    def __init__(self, file_path, timer, onehot=False, reward_scaler=1e6, op_age=min, save_ll=False):
        super(LLVMEnv, self).__init__()

        self.file_path = file_path

        self.reward_scaler = reward_scaler
        self.timer = timer
        self.extremum = op_age
        self.onehot = onehot
        self.MAX_AGE = 10
        self.save_ll = save_ll

        self.instr_to_opcode = {
            "alloca": 1,
            "store": 2,
            "load": 3,
            "fadd": 4,
            "fsub": 5,
            "fmul": 6,
            "fdiv": 7,
            "other": 8
        }

        # self.instr_to_opcode = {
        #     "alloca": 1,
        #     "store": 2,
        #     "load": 3,
        #     "add": 4,
        #     "sub": 5,
        #     "mul": 6,
        #     "div": 7,
        #     "other": 8
        # }

        self.max_step = 50000
        self.curr_step = 0


        # 2 actions: choose instruction or not.
        self.action_space = spaces.Discrete(2)
        if not self.onehot:
            self.observation_space = spaces.Box(low=np.array([0, 0, 0, 0]), 
                                                high=np.array([8, 8, 8, self.MAX_AGE]), 
                                                dtype=int)
        else:
            low = np.append(np.array([0]*3*(len(self.instr_to_opcode)+1)), 
                            np.array([0]*(self.MAX_AGE + 1)))
            high = np.append(np.array([1]*3*(len(self.instr_to_opcode)+1)), 
                             np.array([1]*(self.MAX_AGE + 1)))

            self.observation_space = spaces.Box(low=low, high=high, dtype=int)


        self.selected_instruction = None  # current selected instruction
        self.schedulable_instructions = None

        # last 2 scheduled instructions's opcode
        self.history = collections.deque([0, 0], 2)

        self.llvm = LLVMController(self.file_path)

    def add_instruction(self):

        self.llvm.curr_instr_graph.remove_node(self.selected_instruction)
        # if self.selected_instruction.opcode in MEMORY_INSTR:
        #     self.llvm.curr_memory_graph.remove_node(self.selected_instruction)

        self.llvm.scheduled_instructions.append(self.selected_instruction)
        # update the schedulable instruction list
        self.schedulable_instructions = self.llvm.find_schedulable_instructions()
        self.history.append(self.to_opcode(self.selected_instruction))
        

    def step(self, action):
    
        self.curr_step += 1
        if self.curr_step > self.max_step:
            done = True
            next_state = None
            reward = 0
            print(f"[episode done] reward: {reward} -- nb. steps: {self.curr_step} -- avg. nb of  shedul. instr.: {np.mean(self.nb_shedulables)}")
            return next_state, reward, done, {}

        self.nb_shedulables.append(len(self.schedulable_instructions))
        
        # if the agent has chosen to schedule the instruction
        if action == 0:
            self.add_instruction()

        done = len(self.schedulable_instructions) == 0

        if done:
            next_state = None
            self.run_time = self.llvm.run(self.timer, self.save_ll)
            reward = int(30 -  (round(self.run_time,2)*self.reward_scaler))
            print(f"[episode done] reward: {reward} -- nb. steps: {self.curr_step} -- avg. shedul. instr.: {np.mean(self.nb_shedulables)} -- run time: {self.run_time} ")
        else:
            reward = 0
            next_instruction_opcode = self.select_next_instruction(self.schedulable_instructions)
            next_state = self.update_state(next_instruction_opcode)
        

        return next_state, reward, done, {"run_time": self.run_time}

    def update_state(self, next_instruction_opcode):
        state = list()
        not_encoded = list()
        state.extend(self.history)
        not_encoded.extend((self.history))
        state.append(next_instruction_opcode)
        not_encoded.append(next_instruction_opcode)
        if self.onehot:
            state = self.oneHotInstructions(state)

        operands_ages = self.compute_operands_ages()
        not_encoded.append(operands_ages)
        if self.onehot:
            operands_ages = self.oneHotAge(operands_ages)
            state.extend(operands_ages)
        else:
            state.append(operands_ages)
        # print("not encoded")
        # print(not_encoded)
        return np.array(state)

    def oneHotInstructions(self, state):
        encoded_states = np.array([])
        for elem in state:
            encoded = np.zeros(len(self.instr_to_opcode) + 1)
            encoded[elem] = 1 
            encoded_states = np.append(encoded_states, encoded)
        return list(encoded_states)
    
    def oneHotAge(self, age):
        encoded = np.zeros(self.MAX_AGE + 1)
        encoded[age] = 1
        return list(encoded)

    def select_next_instruction(self, instructions):
        """
        Chooses 1 instruction among the schedulables ones to be proposed to the agent
        update the selected_instruction attribute and return the opcode of the instruction
        """
        self.selected_instruction =  random.choice(instructions)
        instruction_opcode = self.to_opcode(self.selected_instruction)
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
                op_age= 0
            else:
                op_age = len(self.llvm.scheduled_instructions) - \
                         self.llvm.scheduled_instructions.index(op)  # current op age
            ages.append(op_age)

        if len(ages) == 0:
            res = 0
        else:
            res = self.extremum(ages)

        return min(res, self.MAX_AGE) # res bounded between 0 and 10

    def render(self):
        print("---ENV---")
        print("Instructions Scheduled ({}):".format(len(self.llvm.scheduled_instructions)))
        for instr in self.llvm.scheduled_instructions:
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
        self.history = collections.deque([0, 0], 2)
        self.schedulable_instructions = self.llvm.find_schedulable_instructions()
        self.nb_shedulables = []
        next_instruction_opcode = self.select_next_instruction(self.schedulable_instructions)
        next_state = self.update_state(next_instruction_opcode)

        return next_state


class LLVMController:

    def __init__(self, file_path):
        with open(file_path, 'r') as file:
            data = file.read()


        self.mod = LLVMParser.parse(file_path)
        self.functions = self.mod.functions
        self.llvm_code = self.get_llvm_code()
        self.original_file = data
    
        self.instr_graphs, self.memory_graphs = self.create_all_graphs()

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

    def get_llvm_code(self):
        llvm_code= []
        for func in self.mod.functions:
            for block in func.blocks:
                for instruction in block.instructions:
                    llvm_code.append(instruction.str_repr)
        return llvm_code


    def create_all_graphs(self):
        """create de instructions dependency and memory dependency graphs for all blocks"""

        print("[env]: creating all memory and instruction graphs... ")

        all_instr_graphs = []
        all_memory_graphs = []
        for function in self.mod.functions:
            function_instr_graph = []
            function_memory_graph = []
            for block in function.blocks:
                instr_graph, memory_graph = create_dependency_graphs(block.instructions)
                function_instr_graph.append(instr_graph)
                function_memory_graph.append(memory_graph)

            all_instr_graphs.append(function_instr_graph)
            all_memory_graphs.append(function_memory_graph)

        return all_instr_graphs, all_memory_graphs

    def get_block_instructions(self):
        return self.functions[self.curr_function].blocks[self.curr_block]

    def init_new_block(self):
        self.new_block = True
        self.scheduled_instructions = []
        self.block_instructions = self.get_block_instructions()
        self.curr_instr_graph = self.instr_graphs[self.curr_function][self.curr_block].copy()
        self.curr_memory_graph = self.memory_graphs[self.curr_function][self.curr_block].copy()

        self.scheduled_instructions.append(self.block_instructions[0])
        self.curr_instr_graph.remove_node(self.block_instructions[0])

    def update_counters(self):
        self.curr_block += 1
        # check if a function is done
        if self.curr_block == len(self.functions[self.curr_function]):
            self.write_reordered_function()
            self.curr_block = 0
            self.curr_function += 1
            self.reordered_blocks = []

    def terminate_block(self):
        # add the terminator instruction
        self.scheduled_instructions.append(self.block_instructions[-1])
        self.reordered_blocks.append(self.scheduled_instructions)

    def find_schedulable_instructions(self):
        # check if we need to start to schedule a new block
        while len(self.scheduled_instructions) == (len(self.block_instructions) - 1):
            self.terminate_block()
            self.update_counters()
            if self.curr_function < len(self.functions):
                self.init_new_block()
            else:
                return []

        self.schedulable_instructions = []

        for instruction in list(self.curr_instr_graph.nodes())[:-1]:
            if self.is_schedulable(instruction):
                self.schedulable_instructions.append(instruction)

        return self.schedulable_instructions

    def is_schedulable(self, instruction):
        # if instruction.opcode in MEMORY_INSTR and self.curr_instr_graph.in_degree(instruction) != 0:
        #     return False
        if self.curr_instr_graph.in_degree(instruction) != 0:
            return False
        return True


    def write_reordered_function(self):
        
        replaced_block = []
        for i, b in enumerate(self.functions[self.curr_function]):
            block_first_instruction = b[0].str_repr
            block_last_instruction = b[-1].str_repr

            to_replace = [reformat_string(inst.str_repr) for inst in self.reordered_blocks[i]]
            replaced_block.extend(to_replace)

            string_start = self.original_file.index(block_first_instruction, self.index_file_start)
            string_end = self.original_file.index(block_last_instruction, string_start) + len(block_last_instruction) - 1
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
       
        # print(self.string_file)
        function_end_index = self.string_file.index(function_last_instruction, function_start_index) + len(function_last_instruction) - 1
        self.function_start = function_end_index

        self.rename_variables(function_start_index, function_end_index, replaced_block)
        


    def rename_variables(self, start, end, replaced_block):
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

        self.curr_block = 0
        self.curr_function = 0
        self.reordered_blocks = []
        self.schedulable_instructions = []
        self.init_new_block()
        self.function_start = 0
        self.index_file_start = 0


    def run(self, timer, save=False):
        print("[env]: running code for evalution...")
        # create llvm file
        print(self.string_file == self.original_file)
        with open("llvm_file.ll", "w") as text_file:
            text_file.write(self.string_file)
    

        # compile it using clang
        subprocess.run(["clang-9",
                        "-O2",
                        "-o", "res", 
                        "llvm_file.ll",
                        "-march=native",
                        "-mllvm", "-enable-misched=false",
                        "-lm",
                        ])
        # time program
        times = []

        # select only one cpu
        pid = os.getpid()
        os.sched_setaffinity(pid, {0})
        for _ in range(NB_RUNS):
            usage_start = resource.getrusage(resource.RUSAGE_CHILDREN)
            # subprocess.run(["./res"])
            subprocess.run(["./res"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            usage_end = resource.getrusage(resource.RUSAGE_CHILDREN)
            times.append(usage_end.ru_utime - usage_start.ru_utime)
        
        os.sched_setaffinity(pid, {0, 1, 2, 3})

        if not are_equals("reference", "rendered_scene"):
            print("program output problem")
            exit()


        if save:
            Path("saved_ll/").mkdir(parents=True, exist_ok=True)
            with open(f"saved_ll/{str(round(np.mean(times), 4))}.ll", "w") as text_file:
                text_file.write(self.string_file)

        return min(times)

    