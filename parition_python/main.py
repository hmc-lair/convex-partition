# -*- coding: utf-8 -*-
"""

@author: Tianyi Ma
"""

from IPython import get_ipython

def __reset__(): get_ipython().magic('reset -sf')

__reset__()

import numpy as np
import networkx as nx
import computePartition
import matplotlib.pyplot as plt


def main():
    nodeNum = 10 #Number of nodes
    partitionNum = 2 #Number of partitions
    lam = 0.5 #Adjustment for weight

    #Randomly generate node coordinates and probability
    nodeCoords = computePartition.generateRandomNodes(nodeNum)
    nodeProbs = np.random.rand(nodeNum,1)

    #Create the graph
    G = nx.Graph()
    for i in range(nodeNum):
        G.add_node(i,pos=(nodeCoords[i,0], nodeCoords[i,1]), prob=nodeProbs[i])
    pos = nx.get_node_attributes(G,'pos')
    prob = nx.get_node_attributes(G,'prob')
    nx.draw(G, pos)

    #Extract the nodes from the graph
    nodes = list(G.nodes())

    #Compute the adjacency matrix.
    distMatrix = computePartition.generatePlanarGraph(nodes, nodeCoords)

    #Given an adjacency matrix, add edges
    for i in range(nodeNum):
        for j in range(nodeNum):
            if distMatrix[i,j] == 0:
                #do nothing
                continue
            else:
                G.add_edge(i,j,weight = distMatrix[i,j])

#    #Generate weights of the graph
#    weightMatrix = computePartition.calculateWeights(lam,prob,np.array(distMatrix))

    #Compute the parition
    flatDistMatrix = distMatrix.flatten() #Flatten the matrix so it can be
                                              #read by the algorithm.
    flatProbMatrix = nodeProbs.flatten()#just to remove the outisde container matrix
    bases = computePartition.computePartition(nodes, partitionNum, flatDistMatrix,
                                              flatProbMatrix)

    #Plot the graph with nodal names on nodes
    plt.figure(1)
    nx.draw(G, pos)
    nx.draw_networkx_labels(G,pos)

    #Plot the graph with nodal proability on nodes
    plt.figure(2)
    roundedProb = dict(prob)
    for key in roundedProb:
        roundedProb[key] = np.round(roundedProb[key],2)
    nx.draw(G, pos)
    nx.draw_networkx_labels(G,pos, labels = roundedProb)
    plt.show()
    print("Bases")
    print(bases) #Print the partitions.
    #{5: [0, 1, 2, 4, 5, 6, 7], 8: [3, 8, 9]} indicates two partitions.
    #the first partition uses node 5 as the base and includes 0, 1, 2, 4, 5, 6, 7
    #the second partition uses node 8 as the base and includes 3, 8, 9

    #print("Weight Matrix")
    #print(weightMatrix)
    #print('Adj Matrix')
    #print(adjMatrix)

    #The amount of the time spent at the node with respect to the total time.
    #The higher, the better.

if __name__ == "__main__":
    main()
