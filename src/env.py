import gym
import random
import numpy as np
import time
import collections
import os
import copy
import timeit
import re

from gym import spaces
from utils import *
from ctypes import CFUNCTYPE, c_int32
# from sklearn.preprocessing import OneHotEncoder

import llvmlite.ir as ll
import llvmlite.binding as llvm


class LLVMEnv(gym.Env):

    def __init__(self, file_path):
        super(LLVMEnv, self).__init__()

        self.file_path = file_path

        self.instr_to_opcode = {
            "alloca": 0,
            "store": 1,
            "load": 2,
            "add": 3,
            "sub": 4,
            "mul": 5,
            "sdiv": 6,
            "other": 7
        }

        # 2 actions: choose instruction or not.
        self.action_space = spaces.Discrete(2)
        # self.observation_space = spaces.Discrete(len(self.instr_to_opcode))  # 1 state per instruction
        self.observation_space = spaces.Box(low=np.array([-1, -1, 0, 0]), high=np.array([7, 7, 7, 10]), dtype=int)

        self.selected_instruction = None  # current selected instruction
        self.schedulable_instructions = None

        # last 2 scheduled instructions's opcode
        self.history = collections.deque([-1, -1], 2)

        self.llvm = LLVMController(self.file_path)

    def step(self, action):

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
            reward = 1
            next_state = None
            llvm_ir = self.llvm.write_module()
            reward = -self.llvm.run(llvm_ir) * 1000000
        else:
            reward = 0
            next_instruction_opcode = self.select_next_instruction(self.schedulable_instructions)
            next_state = self.update_state(next_instruction_opcode)

        return next_state, reward, done, {}

    def update_state(self, next_instruction_opcode):
        state = list()
        state.extend(self.history)
        state.append(next_instruction_opcode)
        operands_ages = self.compute_operands_ages()
        state.append(operands_ages)
        return np.array(state)

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
        max age of the current instruction's operands.
        The age of an operand is defined as the number of instructions between
        itself and the current instruction. The max age is 10
        """
        max_age = 99999
        for op in self.selected_instruction.operands:
            if op not in self.llvm.scheduled_instructions:
                operands_age = 0
            else:
                op_age = len(self.llvm.scheduled_instructions) - \
                         self.llvm.scheduled_instructions.index(op)  # current op age
                if op_age > max_age:
                    max_age = op_age

        return min(max_age, 10)

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
        self.history = collections.deque([-1, -1], 2)
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

        self.blocks = self.get_blocks()
        self.instr_graphs, self.memory_graphs = self.create_all_graphs()

        self.curr_block = 0
        self.rescheduled_blocks = []  # blocks with new order of instructions
        self.curr_llvm_file = copy.deepcopy(self.llvm_file)

        self.block_instructions = []
        self.scheduled_instructions = []
        self.schedulable_instructions = []

        self.curr_instr_graph = None
        self.curr_memory_graph = None

    def get_blocks(self):
        blocks = []
        for func in self.mod.functions:
            for block in func.blocks:
                block_instructions = []
                for instruction in block.instructions:
                    print(instruction)
                    block_instructions.append(instruction)
                blocks.append(block_instructions)
        return blocks

    def create_all_graphs(self):
        """create de instructions dependency and memory dependency graphs for all blocks"""
        instr_graphs = []
        memory_graphs = []
        for block in self.blocks:
            instr_graph, memory_graph = create_dependency_graphs(block)
            instr_graphs.append(instr_graph)
            memory_graphs.append(memory_graph)
        return instr_graphs, memory_graphs

    def get_block_instructions(self):
        return self.blocks[self.curr_block]

    def init_new_block(self):
        self.scheduled_instructions = []
        self.block_instructions = self.get_block_instructions()

        self.curr_instr_graph = self.instr_graphs[self.curr_block].copy()
        self.curr_memory_graph = self.memory_graphs[self.curr_block].copy()

    def find_schedulable_instructions(self):
        # check if we need to start to schedule a new block
        if len(self.scheduled_instructions) == (len(self.block_instructions) - 1):
            self.terminate_block()
            self.curr_block += 1
            if self.curr_block < len(self.blocks):
                self.init_new_block()
            else:
                return []

        self.schedulable_instructions = []

        if len(self.block_instructions) == 1:
            self.curr_block += 1
            if self.curr_block < len(self.blocks):
                self.init_new_block()
            self.rescheduled_blocks.append(self.scheduled_instructions)
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

    def is_block_instruction(self, operand):
        return operand in self.blocks[self.curr_block]

    def terminate_block(self):
        # add the terminator instruction
        self.scheduled_instructions.append(self.block_instructions[-1])
        self.rescheduled_blocks.append(self.scheduled_instructions)

    def write_module(self):
        # print(self.llvm_file)
        for i, b in enumerate(self.blocks):
            first_instruction = reformat_string(str(b[0]))
            last_instruction = reformat_string(str(b[-1]))

            # print()

            start = self.curr_llvm_file.index(first_instruction)
            end = self.curr_llvm_file.index(last_instruction, start)

            # print(start)
            # print(end)
            # print(self.rescheduled_blocks[i])

            to_replace = [reformat_string(str(inst)) for inst in self.rescheduled_blocks[i]]

            if len(b) != 1:
                self.curr_llvm_file[start: end + 1] = to_replace
            else:
                self.curr_llvm_file[start: end] = to_replace

        llvm_ir = list_to_string(self.curr_llvm_file)
        llvm_ir = rename_percentages(self.curr_llvm_file, llvm_ir)
        return llvm_ir

    def reset(self):
        self.curr_llvm_file = copy.deepcopy(self.llvm_file)
        self.curr_block = 0
        self.rescheduled_blocks = []
        self.schedulable_instructions = []
        self.init_new_block()

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

    def run(self, llvm_ir):
        llvm.initialize()
        llvm.initialize_native_target()
        llvm.initialize_native_asmprinter()
        engine = self.create_execution_engine()
        mod = self.compile_ir(engine, llvm_ir)

        # Look up the function pointer (a Python int)
        func_ptr = engine.get_function_address("main")

        # Run the function via ctypes
        cfunc = CFUNCTYPE(c_int32)(func_ptr)
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
        # print(func())

        min_time = 9999
        nb_runs = 100000
        for _ in range(nb_runs):
            start = time.perf_counter()
            func()
            end = time.perf_counter()
            ex_time = end - start
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
