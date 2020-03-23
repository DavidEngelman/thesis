from dataclasses import dataclass
from typing import List
import re

@dataclass
class Instruction:
    str_repr: str
    var_name: str
    operands: List
    opcode: str

    def __str__(self):
        return f"{self.str_repr}\n"
    def __repr__(self):
        return self.__str__()
    def __hash__(self):
        return hash(id(self))


@dataclass
class Block:
    instructions: List[Instruction]

    def __len__(self):
        return len(self.instructions)

    def __getitem__(self, index):
        return self.instructions[index]

@dataclass
class Function:
    blocks: List[Block]

    def __len__(self):
        return len(self.blocks)

    def __getitem__(self, index):
        return self.blocks[index]


@dataclass
class Module:
    functions: List[Function]

    def __str__(self):
        string = ""
        for function in self.functions:
            string += "FUNCTION\n"
            for block in function.blocks:
                string += "NEW BLOCK\n"
                for instr in block.instructions:
                    string += str(instr)
                string += "\n"
            string += "---------\n"
        return string


class LLVMParser:

    @staticmethod  
    def parse(path):

        with open(path, 'r') as f:
             file = f.readlines()

        module =  Module([])

        in_function = False
        is_multi_line_instr = False

        curr_function = Function([])
        curr_block = Block([])

        module = Module([])

        for line in file:
            
            s_line = line.rstrip().split()

            if len(s_line) == 0 and not in_function:
                continue
            
            # new block
            elif len(s_line) == 0:
                curr_function.blocks.append(curr_block)
                curr_block = Block([])
            
            elif LLVMParser.to_ignore(line):
                continue
                
            
            # end of function
            elif s_line[0] == "}":
                curr_function.blocks.append(curr_block)
                module.functions.append(curr_function)
                curr_function = Function([])
                in_function = False
            
            # new function
            elif s_line[0] == "define":
                in_function = True
                curr_function = Function([])
                curr_block = Block([])

            # instruction line
            else:
                if not is_multi_line_instr:
                    clean_line = line.strip().split()
                    str_repr = line.rstrip()
                    var_name = None
                    if "=" in clean_line:
                        opcode = clean_line[2]
                        var_name = clean_line[0]
                        operands = LLVMParser.get_operands(list_to_string(clean_line[2:]), curr_block.instructions)
                    else:
                        opcode = clean_line[0]
                        operands = LLVMParser.get_operands(list_to_string(clean_line), curr_block.instructions)
                    if opcode in ["switch"]:
                        is_multi_line_instr = True
                        multi_line_instr = line

                    if not is_multi_line_instr:
                        instr = Instruction(str_repr, var_name, operands, opcode)
                        curr_block.instructions.append(instr)
                        
                else:
                    multi_line_instr += line
                    if "]" in s_line:
                        operands = LLVMParser.get_operands(multi_line_instr, curr_block.instructions)
                        instr = Instruction(multi_line_instr, var_name, operands, opcode)
                        curr_block.instructions.append(instr)
                        is_multi_line_instr = False

        return module
    
    @staticmethod
    def get_operands(string, curr_block:List[Instruction]):
        operands = []
        var_names = set(re.findall(r"%[0-9]+", string))
        for instr in curr_block:
            if instr.var_name in var_names:
                operands.append(instr.str_repr)
        return operands


    @staticmethod
    def to_ignore(line):
        return (not line[0].isspace() and line[0] != "}" and line[0:6] != "define" ) or (line[0] == "declare")


def list_to_string(list):
    str1 = " " 
    return (str1.join(list)) 


if __name__ == "__main__":
    module = LLVMParser.parse('../c-ray/c-ray-f-2.ll')
    opcodes = list()
    for func in module.functions:
        for block in func.blocks:
            for instr in block.instructions:
                opcodes.append(instr.opcode)


    opcodes = list(set(opcodes))
    opcodes = sorted(opcodes)
    for elem in opcodes:
        print(elem)