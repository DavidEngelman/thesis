import sys

import llvmlite.ir as ll
import llvmlite.binding as llvm 

filepath = sys.argv[1]

with open(filepath, 'r') as file:
    data = file.read()
# print(data)

mod = llvm.parse_assembly(data)


for func in mod.functions:
    print('=== New function ===')
    for block in func.blocks:
        print('=== New block ===')
        for instruction in block.instructions:
            print("------")
            print("instuction:")
            print(instruction)
            print("opcode:")
            print(instruction.opcode)
            print("operands:")
            for op in instruction.operands:
                print(op)

