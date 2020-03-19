import networkx as nx
import itertools as it
import re
import cv2
import numpy as np


# MEMORY_INSTR = ["load", "store", "fptoui", "getelementptr", "fptrunc", "bitcast", "call"]
MEMORY_INSTR = ["load", "store", "getelementptr", "bitcast", "phi",  "call"]
# MEMORY_INSTR = ["load", "store", "fptoui",  "call"]


def reformat_string(s):
    # # handle struct variable case:
    # s = handle_struct(s, struct_types)
    s = s + "\n"
    return s


def rename_with_prefix(items, _from, to, to_ignore, names):
    res = items
    i = 0
    for line in items:
        if len(line.strip()) != 0 and line.strip()[0] == "%":
            # print(line, i, len(names))
            var_name = line.strip().split(" ")[0][1:]
            if var_name in to_ignore:
                continue
            for index, instr in enumerate(items):
                res = [re.sub(rf"[{_from}{var_name}]", to + str(names[i]), instr) for instr in res]
                res[index] = instr
            i += 1

    return res





def create_dependency_graphs(block):
    """An instruction depend on another one if it contains it in its operand"""
    instr_g = nx.DiGraph()
    mem_g = nx.DiGraph()
    # add all block instructions to the graph
    for i in block:
        instr_g.add_node(i)
        if i.opcode in MEMORY_INSTR:
            mem_g.add_node(i)
            if i.opcode not in ["store", "phi"]:
                # add dependency between node i and all memory node before it
                mem_g.add_edges_from([(node, i) for node in list(mem_g.nodes)[:-1]])
            
    # create instr dependencies
    nodes_combinations = it.combinations(instr_g.nodes, 2)
    for instr1, instr2 in nodes_combinations:
        if depends_on(instr1, instr2):
            instr_g.add_edge(instr2, instr1)
        elif depends_on(instr2, instr1):
            instr_g.add_edge(instr1, instr2)
    return instr_g, mem_g


def depends_on(instr1, instr2):
    return instr2 in instr1.operands

def get_load_dependencies(instr, others, block):
    res = []
    instr_operands = list(instr.operands)
    for o_instr in others:
        if  o_instr.opcode == "store" and have_common_operand(o_instr.operands, instr_operands, block):
            res.append(o_instr)
    return res



def is_before(i1, i2, block):
    return block.index(i1) < block.index(i2)


def have_common_operand(op_list1, op_list2, block):
    common_op = list(set(op_list1).intersection(op_list2))
    for op in common_op:
        if op not in block:
            common_op.remove(op)

    return len(common_op) != 0


def list_to_string(l):
    s = ""
    for elem in l:
        s += elem
    return s + "\n"


def are_equals (path1, path2):
    im1 = cv2.imread(path1)
    im2 = cv2.imread(path2)
    difference = cv2.subtract(im1, im2)
    b, g, r = cv2.split(difference)
    if cv2.countNonZero(b) == 0 and cv2.countNonZero(g) == 0 and cv2.countNonZero(r) == 0:
        return True