import networkx as nx
import matplotlib.pyplot as plt
import itertools as it
import re

MEMORY_INSTR = ["load", "store"]


def reformat_string(s, struct_types):
    # # handle struct variable case:
    # s = handle_struct(s, struct_types)
    s = s + "\n"
    return s


# def handle_struct(s, struct_types):
#     if len(struct_types) == 0:
#         return s
#     for struct in struct_types:
#         if struct in s:
#             print('s')
#             print(s)
#             print('struct')
#             print(struct)
#             s_ok = re.sub(rf"{struct}[.]\d", struct, s)
#             print("s_ok")
#             print(s_ok)
#             return s_ok
#             # TODO check que c'est ok
#     return s

def rename_percentages(f_list, f_string):
    var_num = []
    for line in f_list:
        if len(line.strip()) != 0 and line.strip()[0] == "%":
            real_instr_num = line.strip().split(" ")[0][1:]
            var_num.append(int(real_instr_num))

    var_num.sort()
    i = 0
    new_file = f_string
    for line in f_list:
        if len(line.strip()) != 0 and line.strip()[0] == "%":
            real_instr_num = line.strip().split(" ")[0][1:]

            new_file = new_file.replace("%" + str(real_instr_num) + " ", "@&@'" + str(var_num[i]) + " ")
            new_file = new_file.replace("%" + str(real_instr_num) + ",", "@&@'" + str(var_num[i]) + ",")
            new_file = new_file.replace("%" + str(real_instr_num) + "\n", "@&@'" + str(var_num[i]) + "\n")

            i += 1
    new_file = new_file.replace("@&@'", '%')
    return new_file

def create_dependency_graphs(block):
    """An instruction depend on another one if it contains it in its operand"""
    instr_g = nx.DiGraph()
    mem_g = nx.DiGraph()
    # add all block instructions to the graph
    for i in block:
        instr_g.add_node(i)
        if i.opcode in MEMORY_INSTR:
            mem_g.add_node(i)
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


def is_before(i1, i2, block):
    return block.index(i1) < block.index(i2)


def have_common_operand(op_list1, op_list2, block):
    common_op = list(set(op_list1).intersection(op_list2))
    for op in common_op:
        if op in block:
            common_op.remove(op)

    return len(common_op) != 0


def list_to_string(l):
    s = ""
    for elem in l:
        s += elem
    return s
