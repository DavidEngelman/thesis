
"""
Parsing ".s" files
Each instruction is decomposed into its opcode and operands.
"""

from dataclasses import dataclass
from typing import List
import re

@dataclass
class Instruction:
    str_repr: str
    operands: List
    opcode: str

    def __str__(self):
        return f"[{self.opcode}] -- {self.operands}\n"
    def __repr__(self):
        return f"[{self.opcode}] -- {self.operands}\n"

@dataclass
class Block:
    instructions: List[Instruction]

@dataclass
class Module:
    blocks: list

    def __str__(self):
        string = ""
        for block in self.blocks:
            string += "NEW BLOCK\n"
            for instr in block:
                string += str(instr)
            string += "---------\n"
        return string


class ASMParser:

    @staticmethod  
    def parse(path):

        with open(path, 'r') as f:
             file = f.readlines()

        module =  Module([])
        print(file)
        curr_block = []
        for line in file:
            # new block
            if not line[0].isspace()  and len(curr_block) != 0:
                # print('line')
                # print(line)
                # print(line[0])
                module.blocks.append(curr_block)
                curr_block = []
            # instruction line
            else:
                cleaned_line = ASMParser.clean(line)
                splitted = cleaned_line.split(maxsplit=1)
                if len(splitted) != 0:
                    opcode = splitted[0]
                    operands = []
                    if len(splitted) > 1:
                        operands = re.split(',', splitted[1])
                        operands = [elem.strip() for elem in operands]
                    instr = Instruction(line, operands, opcode)
                    curr_block.append(instr)

        return module
            


    @staticmethod
    def clean(line):
        res = line.strip()
        if "#" in line:
            index = line.index("#")
            res = line[:index]
        return res




if __name__ == "__main__":

    module = ASMParser.parse('../c-ray/c-ray-f-2.s')
    print(module)
    print(len(module.blocks))
