# -*- coding: utf-8 -*-
"""

@author: Tianyi Ma
"""

import gurobipy
import p_median
import numpy as np
import networkx as nx

def computePartition(nodes, partitionNum, weightVals):
    """Compute the partition based on nodal positions and number of partitions
        Input:  nodes, a list of all nodes
                partitionNum, the number of paritions we want.
                weightVals, a list of the weight between nodes. It is a 1d list.
    """
    demandVals = [1]*len(nodes)
    baseSet = nodes
    m,x,y = p_median.p_median(nodes, baseSet, partitionNum, demandVals, weightVals)
    xoutDict = m.getAttr('X',x)
    youtDict = m.getAttr('X',y) 
    bases = {}
    for key in xoutDict:
       if xoutDict[key] == 1:
           bases[key] = []
       
    for key in youtDict:
        if youtDict[key] == 1:
            q = key[1]
            bases[q].append(key[0])
    return bases


def generatePlanarGraph(nodes, nodeCoords):
    """Generate a planar graph based on the nodes and nodal positions
    Input:  nodes: a list with node names
            nodeCoords: a 2d np array of x y coordinates of nodes. x, y coordinates
            range from 0 to 1. nodeCoords[0,0] is the x coord of the first node.
            nodeCoords[0,1] is the y coord of the first node.
    Output: adjacencyMatrix: a 2d np array that stores the distance and
            connectivity between two nodes. adjacencyMatrix[i,j] is the distance
            between node i and node j. It is zero if i and j are not connected.
    """
    #Nodes is a 2d array with x,y values of each node stored.
    
    #Calculate distance matrix
    distMatrix = calculateDistanceMatrix(nodeCoords)

    baseSet_Used = []
    baseSet_Remain = list(nodes)
    demandVals = [1]*len(nodes)
    currDistMatrix = np.array(distMatrix)
    adjacencyMatrix = np.zeros([len(nodes),len(nodes)])
    currEdges = []
    
    
    while len(baseSet_Remain) > 0:
        flatDistMatrix = currDistMatrix.flatten()
        # Find the central node using the 1-median algorithm 
        center = p_median.find_central_node(
                nodes, baseSet_Remain, demandVals, flatDistMatrix)
        
        # Update the sets
        baseSet_Used.append(center)
        baseSet_Remain.remove(center)
        
        #Try to connect the center with all the other nodes. Do not connect
        #if it intersects with existing edges
        for i in range(len(nodes)):

            #If the edge set is empty, directly add the first edge
            if not currEdges:
                adjacencyMatrix[center, i] = currDistMatrix[center, i]
                currEdges.append((center,i))
            #Else, check whether the edge intersects with other edges    
            else:
                A = nodeCoords[center]
                B = nodeCoords[i]
                temp = list(currEdges)  #Create a copy because the for loop below
                                        #changes currEdges
                for j in range(len(temp)):
                    pair = temp[j]
                    C = nodeCoords[pair[0]]
                    D = nodeCoords[pair[1]]
                    
                    #If edge (center, i) does not intersect any of current
                    #existing edge
                    if (not intersect(A,B,C,D)) and (j == len(temp) - 1):
                        adjacencyMatrix[center, i] = currDistMatrix[center, i]
                        currEdges.append((center,i))
                    #If edge (center, i) does not intersect with this edge pair,
                    #try the other remaining edges
                    elif not intersect(A,B,C,D):
                        continue
                    #If edge (center, i) intersect with edge pair, set this element
                    #of the adjacency matrix to 0.
                    else:
                        adjacencyMatrix[center, i] = 0
                        break
                         
    return adjacencyMatrix


# Adopted from the C++ codes on 
# https://www.geeksforgeeks.org/check-if-two-given-line-segments-intersect/
def orientation(A,B,C):
    """ To find orientation of ordered triplet (A, B, C).
        The function returns following values
        0 --> A, B and C are colinear
        1 --> Clockwise
        2 --> Counterclockwise
    """
    val = (B[1]-A[1])*(C[0]-B[0]) - (B[0]-A[0])*(C[1]-B[1]) 
    if val == 0:
        return 0
    if val > 0:
        return 1
    if val < 0:
        return 2


def intersect(A,B,C,D):
    """Check whether AB and CD intersect. Return True if intersect and False
        otherwise.
    """
    o1 = orientation(A,B,C)
    o2 = orientation(A,B,D)
    o3 = orientation(C,D,A)
    o4 = orientation(C,D,B)
    coords = tuple(map(tuple, [A,B,C,D]))
    if len(list(set(coords))) < 4:
        return False
    elif (o1 != o2 and o3 != o4):
        return True
    else:
        return False


def generateRandomNodes(nodesNum):
    """Generate random nodes given the node number
    Input:  int nodesNum, the number of nodes want to generate
    Output: nodeCoords, a 2d np array of x y coordinates of nodes. x, y coordinates
            range from 0 to 1. nodeCoords[0,0] is the x coord of the first node.
            nodeCoords[0,1] is the y coord of the first node.
    """
    nodeCoords = np.random.rand(nodesNum,2)
    return nodeCoords # A 2d array of x y coordinates of nodes


def calculateDistanceMatrix(nodeCoords):
    """Compute the distance matrix given nodal coordinates
    Input:  nodeCoords, a 2d np array of x y coordinates of nodes. x, y coordinates
            range from 0 to 1. nodeCoords[0,0] is the x coord of the first node.
            nodeCoords[0,1] is the y coord of the first node.
    Output: dMatrix, a 2d np array that stores the distance between nodes.
            dMatrix[i,j] is the distance between node i to node j.
    """
    # nodes 2d array
    dMatrix = np.empty([len(nodeCoords),len(nodeCoords)])
    for i in range(len(nodeCoords)):
        for j in range(len(nodeCoords)):
            x1 = nodeCoords[i][0]
            y1 = nodeCoords[i][1]
            x2 = nodeCoords[j][0]
            y2 = nodeCoords[j][1]
            dMatrix[i,j] = np.sqrt(np.square(x1 - x2) + np.square(y1 - y2))
    return dMatrix

def calculateWeights(lam,prob,distMatrix, M = 10000):
    """This function calculates the weight matrix based on the nodal probability
    and distance between nodes.
    Input:  lam, a constant for adjusting the ratio between the prob term and
            distance term.
            prob, a list of probability of each node
            distMatrix, a 2d np array that stores the distance betwen nodes.
            dist[i,j] is the distance between node i and j. It equals to 0 if
            two nodes are not connected.
            M, the penalty value used
    """
    weightMatrix = np.array(distMatrix)
    for i in range(len(prob)):
        for j in range(len(prob)):
            #The cost of transisting to itself is 0
            if i == j:
                weightMatrix[i,j] = 0
            elif distMatrix[i,j] != 0:
                #weightMatrix[i,j] = lambda * 1/(Pi-Pj) + (1-lambda) * d_{i,j}
                #
                probTerm = lam * (np.minimum(1/ (np.abs(prob[i] - prob[j])), 100))
                distTerm = 100*weightMatrix[i,j]*(1-lam) #100 is to adjust distTerm
                                                         #to make it comparable with
                                                         #the prob term
                weightMatrix[i,j] = distTerm + probTerm
            else:
                weightMatrix[i,j] = M #Penalize the using a really large value
    return weightMatrix