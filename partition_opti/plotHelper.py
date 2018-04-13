# -*- coding: utf-8 -*-
"""
Created on Fri Apr 13 03:04:41 2018

@author: lenovo
"""

import numpy as np
import scipy.io
import networkx as nx
import matplotlib.pyplot as plt

mat1 = scipy.io.loadmat('nodes_partition.mat')
nodes_partition = np.array(mat1["nodes_partition"])

mat2 = scipy.io.loadmat('nodes_x.mat')
nodes_x = np.array(mat2["nodes_x"])
mat3 = scipy.io.loadmat('nodes_y.mat')
nodes_y = np.array(mat3["nodes_y"])
mat4 = scipy.io.loadmat('nodes_prob.mat')
nodes_prob = np.array(mat4["nodes_prob"])

G = nx.Graph()
for i in range(len(nodes_x)):
    G.add_node(i,pos=(nodes_x[i], nodes_y[i]), prob=nodes_prob[i], labels = nodes_partition[i][0])
pos = nx.get_node_attributes(G,'pos')
prob = nx.get_node_attributes(G,'prob')
labels = nx.get_node_attributes(G,'labels')
nx.draw_networkx_nodes(G,pos)
nx.draw_networkx_labels(G,pos,labels,font_size=14)

