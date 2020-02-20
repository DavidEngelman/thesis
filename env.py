import gym
import sys
import random

from gym import spaces
from utils import *
from ctypes import CFUNCTYPE, c_int32

import llvmlite.ir as ll
import llvmlite.binding as llvm
import time
# from recordclass import recordclass




class LLVMEnv(gym.Env):

    def __init__(self, file_path):
        super(LLVMEnv, self).__init__()

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
        self.observation_space = spaces.Discrete(
            len(self.instr_to_opcode))  # 1 state per instruction

        self.llvm = LLVMController(file_path)
        self.selected_instruction = None

    def step(self, action):

        # if the agent has chosen to schedule the instruction
        if action == 0:
            self.llvm.instructions_to_schedule.remove(self.selected_instruction)
            self.llvm.scheduled_instructions.append(self.selected_instruction)
            # update the schedulable instruction list
            schedulable_instructions = self.llvm.find_schedulable_instructions()

        done = len(self.llvm.schedulable_instructions) == 0

        if done:
            next_state = None
            reward = 1
            llvm_ir = self.llvm.write_module()
            print(llvm_ir)
            self.llvm.run(llvm_ir)


        else:
            reward = 0
            next_state = self.select_next_state(schedulable_instructions)
        

        return next_state, reward, done

    def reset(self):
        self.llvm.reset()
        schedulable_instructions = self.llvm.find_schedulable_instructions()
        state = self.select_next_state(schedulable_instructions)
        return state

    def select_next_state(self, instructions):
        # choose 1 instructions among the schedulables ones to be proposed to the agent
        self.selected_instruction = random.sample(instructions, 1)[0]
        # transform instruction to a valid env state
        if not str(self.selected_instruction.opcode).strip() in self.instr_to_opcode:
            state = self.instr_to_opcode["other"]
        else:
            state = self.instr_to_opcode[str(
                self.selected_instruction.opcode).strip()]
        return state 

    def render(self):
        print("---ENV---")
        print("Instructions Scheduled ({}):".format(len(self.llvm.scheduled_instructions)))
        for instr in self.llvm.scheduled_instructions:
            print(instr)
        print("Schedulable Instructions:")
        for instr in self.llvm.schedulable_instructions:
            print(instr)
        print('------')


class LLVMController:

    def __init__(self, file_path):
        with open(file_path, 'r') as file:
            data = file.read()
            self.llvm_file = file.readlines()
        with open(file_path, 'r') as file:
            self.llvm_file = file.readlines()

        self.mod = llvm.parse_assembly(data)  # module from the inpute file
        self.blocks = self.get_blocks()
        self.curr_block = 0
        self.rescheduled_blocks = []
                
    def init_new_block(self):
        self.scheduled_instructions = []
        self.schedulable_instructions = []
        self.block_instructions = self.get_block_instructions()
        self.instructions_to_schedule = self.block_instructions[:-1] #everything but the terminator instruction
        self.memory_graph = create_memory_dependency_graph(self.blocks[self.curr_block])


    def get_blocks(self):
        blocks = []
        for func in self.mod.functions:
            for block in func.blocks:
                block_instructions = []
                for instruction in block.instructions:
                    block_instructions.append(instruction)
                blocks.append(block_instructions)
        return blocks

    def get_block_instructions(self):
        return self.blocks[self.curr_block]

    def find_schedulable_instructions(self):
        # check if we need to start to schedule a new block
        if len(self.scheduled_instructions) == (len(self.block_instructions) - 1):
            self.terminate_block()
            self.curr_block += 1
            if self.curr_block < len(self.blocks):
                self.init_new_block()

        self.schedulable_instructions = []
        for instruction in self.instructions_to_schedule:
            if self.is_schedulable(instruction):
                self.schedulable_instructions.append(instruction)

        return self.schedulable_instructions

    def is_schedulable(self, instruction):
        for operand in instruction.operands:
            if (self.is_block_instruction(operand)) and not (operand in self.scheduled_instructions):
                return False

        if instruction.opcode in MEMORY_INSTR:
            successors = self.memory_graph.neighbors(instruction)
            return all(elem in self.scheduled_instructions for elem in successors)


        return True

    def is_block_instruction(self, operand):
        return operand in self.blocks[self.curr_block]

    def terminate_block(self):
        # add the terminator instruction
        self.scheduled_instructions.append(self.block_instructions[-1])
        print("Block done")
        self.rescheduled_blocks.append(self.scheduled_instructions)
        # TODO: add the block to the program

    def write_module(self):
        
        print()

        for i, b in enumerate(self.blocks):
            
            first_instruction = reformat_string(str(b[0]).strip())
            last_instruction = reformat_string(str(b[-1]).strip())
            
            start =self.llvm_file.index(first_instruction)
            end = self.llvm_file.index(last_instruction, start)

            to_replace = [reformat_string(str(inst).strip()) for inst in self.rescheduled_blocks[i]]

            self.llvm_file[start : end + 1] = to_replace

        llvm_ir = list_to_string(self.llvm_file)
        llvm_ir = rename_percentages(self.llvm_file, llvm_ir)   
    
        return llvm_ir

    def reset(self):
        self.blocks = self.get_blocks()
        self.curr_block = 0
        self.init_new_block()

    def create_execution_engine(self):
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
    
    def compile_ir(self, engine, llvm_ir):
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
        llvm.initialize_native_asmprinter()  # yes, even this one
        engine = self.create_execution_engine()
        mod = self.compile_ir(engine, llvm_ir)

        # Look up the function pointer (a Python int)
        func_ptr = engine.get_function_address("main")

        # Run the function via ctypes
        cfunc = CFUNCTYPE(c_int32)(func_ptr)
        start = time.perf_counter()
        res = cfunc()
        print("done in " + str(time.perf_counter() - start)  + " s")
        print("main(...) =", res)