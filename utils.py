import networkx as nx
import matplotlib.pyplot as plt


MEMORY_INSTR = ["load", "store"]

def reformat_string(s):
    s = "  " + s + "\n"
    return s


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


def create_memory_dependency_graph(block):
    G = nx.DiGraph()
    # add node to the graph
    for i in block:
        if i.opcode in MEMORY_INSTR:
            G.add_node(i)

    # create edges
    for n1 in G.nodes:
        for n2 in G.nodes:
            # and have_common_operand(list(n1.operands), list(n2.operands), block)
            if n1 != n2 and is_before(n1, n2, block):
                G.add_edge(n2, n1)
    # nx.draw(G, with_labels=True, node_shape='s', pos=nx.circular_layout(G), node_size=600, font_size=6)
    # plt.show()
    return G


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
