import sys
from parse_llvm import LLVMParser
import collections

"""Count for each opcode the number of instrcutions. Take as argument the .'ll' file"""

fp = sys.argv[1]

module = LLVMParser.parse(fp)

instrcutions_opcodes = []

for func in module.functions:
    for block in func.blocks:
        for instruction in block.instructions:
            instrcutions_opcodes.append(instruction.opcode)

counter = collections.Counter(instrcutions_opcodes).most_common()

for k,v in counter:
    print(f"{k}: {v}")