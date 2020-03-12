import collections
import copy
import os
import random
import re
import time
import timeit
from ctypes import CFUNCTYPE, c_int32

import gym
import llvmlite.binding as llvm
import llvmlite.ir as ll
import numpy as np
from gym import spaces
import sys

from .utils import * 

def sizeof_fmt(num, suffix='B'):
    ''' by Fred Cirera,  https://stackoverflow.com/a/1094933/1870254, modified'''
    for unit in ['','Ki','Mi','Gi','Ti','Pi','Ei','Zi']:
        if abs(num) < 1024.0:
            return "%3.1f %s%s" % (num, unit, suffix)
        num /= 1024.0
    return num


MEMORY = {}

class LLVMEnv(gym.Env):

    def __init__(self, file_path, timer, onehot=False, reward_scaler=1e6, op_age=min):
        super(LLVMEnv, self).__init__()

        self.file_path = file_path

        self.reward_scaler = reward_scaler
        self.timer = timer
        self.extremum = op_age
        self.onehot = onehot
        self.MAX_AGE = 10

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

        

    def step(self, action):

        # memory_profile(MEMORY)


        # if the agent has chosen to schedule the instruction
        if action == 0:
            self.llvm.curr_instr_graph.remove_node(self.selected_instruction)

            if self.selected_instruction.opcode in MEMORY_INSTR:
                self.llvm.curr_memory_graph.remove_node(self.selected_instruction)

            self.llvm.scheduled_instructions.append(self.selected_instruction)
            # update the schedulable instruction list
            self.schedulable_instructions = self.llvm.find_schedulable_instructions()
            self.history.append(self.to_opcode(self.selected_instruction))

        done = len(self.schedulable_instructions) == 0

        if done:
        
            next_state = None
            # * 1000000
            reward = -self.llvm.run(self.llvm.string_file, self.timer) * self.reward_scaler
        else:
            reward = 0
            next_instruction_opcode = self.select_next_instruction(self.schedulable_instructions)
            next_state = self.update_state(next_instruction_opcode)

        return next_state, reward, done, {}

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
        self.selected_instruction = random.sample(instructions, 1)[0]
        instruction_opcode = self.to_opcode(self.selected_instruction)
        return instruction_opcode

    def to_opcode(self, instruction):
        """
        Converts the instruction to its opcode
        """
        if not str(instruction.opcode).strip() in self.instr_to_opcode:
            opcode = self.instr_to_opcode["other"]
        else:
            opcode = self.instr_to_opcode[str(instruction.opcode).strip()]
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
        self.llvm.reset()
        self.selected_instruction = None
        self.schedulable_instructions = None
        self.history = collections.deque([0, 0], 2)
        self.schedulable_instructions = self.llvm.find_schedulable_instructions()
        next_instruction_opcode = self.select_next_instruction(self.schedulable_instructions)
        next_state = self.update_state(next_instruction_opcode)
        return next_state


class LLVMController:

    def __init__(self, file_path):
        with open(file_path, 'r') as file:
            data = file.read()
        with open(file_path, 'r') as file:
            self.llvm_file = file.readlines()

        self.mod = llvm.parse_assembly(data)  # module from the inpute file

        # self.blocks = self.get_blocks()
        self.functions = self.get_functions()
        self.instr_graphs, self.memory_graphs = self.create_all_graphs()

        self.curr_function = 0
        self.curr_block = 0

        self.reordered_blocks = []  # blocks of a function with new order of instructions
        self.curr_llvm_file = copy.deepcopy(self.llvm_file)

        self.block_instructions = []
        self.scheduled_instructions = []
        self.schedulable_instructions = []

        self.curr_instr_graph = None
        self.curr_memory_graph = None

        self.function_start = 0

        # def get_blocks(self):

    #     blocks = []
    #     for func in self.mod.functions:
    #         for block in func.blocks:
    #             block_instructions = []
    #             for instruction in block.instructions:
    #                 print(instruction)
    #                 block_instructions.append(instruction)
    #             blocks.append(block_instructions)
    #     return blocks

    def get_functions(self):
        functions = []
        for func in self.mod.functions:
            function_blocks = []
            for block in func.blocks:
                block_instructions = []
                for instruction in block.instructions:
                    block_instructions.append(instruction)
                function_blocks.append(block_instructions)
            if len(function_blocks):
                functions.append(function_blocks)
        return functions

    def create_all_graphs(self):
        """create de instructions dependency and memory dependency graphs for all blocks"""
        instr_graphs = []
        memory_graphs = []
        for function in self.functions:
            for block in function:
                instr_graph, memory_graph = create_dependency_graphs(block)
                instr_graphs.append(instr_graph)
                memory_graphs.append(memory_graph)
        return instr_graphs, memory_graphs

    def get_block_instructions(self):
        return self.functions[self.curr_function][self.curr_block]

    def init_new_block(self):
        self.scheduled_instructions = []
        self.block_instructions = self.get_block_instructions()
        self.curr_instr_graph = self.instr_graphs[self.curr_block].copy()
        self.curr_memory_graph = self.memory_graphs[self.curr_block].copy()

    def update_counters(self):
        self.curr_block += 1
        # check if a function is done
        if self.curr_block == len(self.functions[self.curr_function]):
            self.write_reordered_function()
            self.curr_block = 0
            self.curr_function += 1
            self.reordered_blocks = []

    def find_schedulable_instructions(self):
        # check if we need to start to schedule a new block
        if len(self.scheduled_instructions) == (len(self.block_instructions) - 1):
            self.terminate_block()
            self.update_counters()
            if self.curr_function < len(self.functions):
                self.init_new_block()
            else:
                return []

        self.schedulable_instructions = []

        if len(self.block_instructions) == 1:
            self.update_counters()
            if self.curr_function < len(self.functions):
                self.init_new_block()
            self.reordered_blocks.append(self.scheduled_instructions)
            return [self.block_instructions[0]]

        for instruction in list(self.curr_instr_graph.nodes())[:-1]:
            if self.is_schedulable(instruction):
                self.schedulable_instructions.append(instruction)

        return self.schedulable_instructions

    def is_schedulable(self, instruction):
        if instruction.opcode in MEMORY_INSTR and self.curr_memory_graph.in_degree(instruction) != 0:
            return False
        if self.curr_instr_graph.in_degree(instruction) != 0:
            return False
        return True

    def terminate_block(self):
        # add the terminator instruction
        self.scheduled_instructions.append(self.block_instructions[-1])
        self.reordered_blocks.append(self.scheduled_instructions)

    def write_reordered_function(self):

        function_first_instruction = reformat_string(str(self.reordered_blocks[0][0]))
        function_last_instruction = reformat_string(str(self.reordered_blocks[-1][-1]))

        function_start_index = self.curr_llvm_file.index(function_first_instruction)
        self.function_start = function_start_index
        function_end_index = self.curr_llvm_file.index(function_last_instruction)

        for i, b in enumerate(self.reordered_blocks):
            block_first_instruction = reformat_string(str(b[0]))
            block_last_instruction = reformat_string(str(b[-1]))

            start = self.curr_llvm_file.index(block_first_instruction)
            end = self.curr_llvm_file.index(block_last_instruction, start)

            to_replace = [reformat_string(str(inst)) for inst in self.reordered_blocks[i]]
            if len(b) != 1:
                self.curr_llvm_file[start: end + 1] = to_replace
            else:
                self.curr_llvm_file[start: end] = to_replace

        self.string_file = rename_variables(self.string_file,self.curr_llvm_file, function_start_index, function_end_index)

    def reset(self):

        self.curr_llvm_file = copy.deepcopy(self.llvm_file)
        self.string_file = list_to_string(self.curr_llvm_file)
        self.curr_block = 0
        self.curr_function = 0

        self.reordered_blocks = []
        self.schedulable_instructions = []
        self.init_new_block()

        self.function_start = 0

    @staticmethod
    def create_execution_engine():
        """
        Create an ExecutionEngine suitable for JIT code generation on
        the host CPU.  The engine is reusable for an arbitrary number of
        modules.
        """
        # Create a target machine representing the host
        target = llvm.Target.from_default_triple()
        target_machine = target.create_target_machine()
        # And an execution engine with an empty backing module
        backing_mod = llvm.parse_assembly("")
        engine = llvm.create_mcjit_compiler(backing_mod, target_machine)
        return engine

    @staticmethod
    def compile_ir(engine, llvm_ir):
        """
        Compile the LLVM IR string with the given engine.
        The compiled module object is returned.
        """
        # Create a LLVM module object from the IR
        mod = llvm.parse_assembly(llvm_ir)
        mod.verify()
        # Now add the module and make sure it is ready for execution
        engine.add_module(mod)
        engine.finalize_object()
        engine.run_static_constructors()
        return mod

    def run(self, llvm_ir, timer):
        llvm.initialize()
        llvm.initialize_native_target()
        llvm.initialize_native_asmprinter()
        engine = self.create_execution_engine()
        mod = self.compile_ir(engine, llvm_ir)

        # Look up the function pointer (a Python int)
        func_ptr = engine.get_function_address("main")

        # Run the function via ctypes
        cfunc = CFUNCTYPE(c_int32)(func_ptr)
        if timer == "timer_v1":
            timer = self.time_program(cfunc)
        elif timer == "timer_v2":
            timer = self.time_programV2(cfunc)

        return timer

    @staticmethod
    def time_program(func):
        """
        min running time of a function using perf_counter
        """
        # select only one cpu
        pid = os.getpid()
        os.sched_setaffinity(pid, {0})

        # run the program ones without timing it
        func()

        min_time = 9999
        nb_runs = 3
        for _ in range(nb_runs):
            start = time.perf_counter()
            func()
            end = time.perf_counter()
            ex_time = end - start
            # print(f"ex time: {ex_time}")
            if ex_time < min_time:
                min_time = ex_time

        os.sched_setaffinity(pid, {0, 1, 2, 3})
        # print("done in " + str(time.perf_counter() - start) + " s")
        # print("main(...) =", res)

        return min_time

    @staticmethod
    def time_programV2(func):
        """
        min running time of a function using perf_counter
        """
        # select only one cpu
        pid = os.getpid()
        os.sched_setaffinity(pid, {0})

        # run the program ones without timing it
        func()

        min_time = min(timeit.repeat(func, number=1, repeat=1))

        os.sched_setaffinity(pid, {0, 1, 2, 3})
        # print("done in " + str(time.perf_counter() - start) + " s")
        # print("main(...) =", res)

        return min_time
