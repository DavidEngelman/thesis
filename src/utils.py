import networkx as nx
import itertools as it
import re
import cv2
import numpy as np
import matplotlib.pyplot as plt


MEMORY_INSTR = ["load", "store", "getelementptr", "bitcast",  "call", "tail"]
# MEMORY_INSTR = ["alloca", "load", "store", "fptoui", "getelementptr", "zext", "sext", "fptrunc", "fpext","fptosi", "uitofp", "sitofp", "ptrtoint", "inttoptr", "bitcast",  "icmp", "fcmp", "phi",  "call", "tail", "select", "switch"]
# MEMORY_INSTR = ["load", "store", "getelementptr", "bitcast", "phi",  "call", "tail", "select", "switch"]

def reformat_string(s):
    # # handle struct variable case:
    # s = handle_struct(s, struct_types)
    s = s + "\n"
    return s

def create_dependency_graphs(block):
    """An instruction depend on another one if it contains it in its operand"""
    instr_g = nx.DiGraph()
    mem_g = nx.DiGraph()
    # add all block instructions to the graph
    for i in block:
        instr_g.add_node(i)
        if i.opcode in MEMORY_INSTR:
            mem_g.add_node(i)        
            if i.opcode == "load":
                # add dependency between itself and all other instruction that are not "load"
                instr_g.add_edges_from([(node, i) for node in list(mem_g.nodes)[:-1] if node.opcode != "load"])
            
            elif i.opcode not in ["store"]:
                instr_g.add_edges_from([(node, i) for node in list(mem_g.nodes)[:-1] if not(i.opcode == "getelemptr" and node.opcode == "getelementptr")])
            
    # create instr dependencies
    nodes_combinations = it.combinations(instr_g.nodes, 2)
    for instr1, instr2 in nodes_combinations:
        if depends_on(instr1, instr2):
            instr_g.add_edge(instr2, instr1)
        elif depends_on(instr2, instr1):
            instr_g.add_edge(instr1, instr2)

    # plt.figure(figsize=(18,9))
    # nx.draw_circular(instr_g, with_labels = True)
    # plt.savefig('instr.png')

    # plt.figure(figsize=(18,9))
    # nx.draw_circular(mem_g, with_labels = True)
    # plt.savefig('memory.png')
    
    # exit()
    return instr_g

def depends_on(instr1, instr2):
    return instr2 in instr1.operands



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
    """Checks if 2 images are equal"""
    im1 = cv2.imread(path1)
    im2 = cv2.imread(path2)
    difference = cv2.subtract(im1, im2)
    b, g, r = cv2.split(difference)
    if cv2.countNonZero(b) == 0 and cv2.countNonZero(g) == 0 and cv2.countNonZero(r) == 0:
        return True