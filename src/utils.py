import networkx as nx
import itertools as it
import re

MEMORY_INSTR = ["load", "store"]


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


START = 0
def rename_variables(f_string, f_list, f_string_original, start, end, first_instr, last_instr):
    global START
    names = []
    to_ignore = []
    for line in f_list[start:end + 1]:
        if len(line.strip()) != 0 and line.strip()[0] == "%":
            var_name = line.strip().split(" ")[0][1:]
            try:
                names.append(int(var_name))
            except ValueError:
                to_ignore.append(var_name)

    names.sort()
    i = 0

    string_start = f_string.find(first_instr, START)
    START = string_start
    string_end = f_string.find(last_instr, string_start) + len(last_instr) - 1


    new_string = list_to_string(f_list[start:end + 1])


    for line in f_list[start:end + 1]:
        if len(line.strip()) != 0 and line.strip()[0] == "%":
            real_instr_num = line.strip().split(" ")[0][1:]
            if real_instr_num in to_ignore:
                continue

            new_string = new_string.replace("%" + str(real_instr_num) + " ", "@&@'" + str(names[i]) + " ")
            new_string = new_string.replace("%" + str(real_instr_num) + ",", "@&@'" + str(names[i]) + ",")
            new_string = new_string.replace("%" + str(real_instr_num) + "\n", "@&@'" + str(names[i]) + "\n")
            new_string = new_string.replace("%" + str(real_instr_num) + ")", "@&@'" + str(names[i]) + ")")

            i += 1

    new_string = new_string.replace("@&@'", '%')

    print(new_string)


    f_string = f_string.replace(f_string[string_start:string_end], new_string)

    return f_string

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

