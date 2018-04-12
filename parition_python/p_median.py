# -*- coding: utf-8 -*-
"""

@author: Tianyi Ma
"""
import gurobipy
<<<<<<< HEAD
=======
import numpy as np
>>>>>>> more gurobi

#The AMPL file of p-median 
#param d{I,J};
#param h{I}; #Demand at node i
#param p; #Number of bases
#
## whether edge i,j is being selected
#var y{I,J} binary;
#var x{J} binary;
#
#minimize totalCost:
#  sum{i in I, j in J}(h[i]*d[i,j]*y[i,j]);
#  
#subject to SingleDeliveryCons{i in I}:
#  sum{j in J}(y[i,j]) = 1;
#
#subject to DeliverAllCons:
#  sum{j in J}(x[j]) = p;
#
#subject to SupplyDemandBindCons{i in I, j in J}:
#  y[i,j] <= x[j];
<<<<<<< HEAD
def p_median(nodes, baseSet, baseNum, demandVals, weightVals):
=======

def updateCentroids(model, where):
    if where == gurobipy.GRB.Callback.MIPSOL:
        # make a list of edges selected in the solution
        model._vars = model.getVars()
        vals = model.cbGetSolution(model._vars)
        ylen = int( (-1 + np.sqrt(1 + 4*len(vals)))/2 )
        yvals = np.array(vals[0:ylen**2])
        yvals = np.reshape(yvals,(ylen,ylen))
        print(yvals)
        
        # find the shortest cycle in the selected edge list
#        tour = subtour(selected)
#        if len(tour) < n:
#            # add subtour elimination constraint for every pair of cities in tour
#            model.cbLazy(quicksum(model._vars[i,j]
#                                  for i,j in itertools.combinations(tour, 2))
#                         <= len(tour)-1)


def findCentroid(nodes, nodeCoords):
    """ find the centroid of a given index of nodes and the nodeCoords matrix.
        Input: nodes, a list of nodes in a partition.
               nodeCoords, a 2D np array that stores locations of nodes.
    """
    chosenCoords = nodeCoords[nodes]
    centroid = chosenCoords.sum(axis=0)/len(nodes)
    return centroid

def findTotalDistToCentroid(nodes, nodeCoords):
    centroid = findCentroid(nodes, nodeCoords)
    chosenCoords = nodeCoords[nodes]
    totalDist = 0
    for i in range(len(nodes)):
        # dist = sqrt((x-xc)^2 + (y-yc)^2)
        totalDist += np.sqrt(np.square(chosenCoords[i,0] - centroid[0]) + \
        np.square(chosenCoords[i,1] - centroid[1]))
    return totalDist


def p_median_modified(nodes, baseSet, baseNum, demandVals, distVals, probVals):
    """Solves the p-median problem using the Gurobi solver. 
        Input:  nodes, a list of all nodes
            baseSet, a list of potential bases. It is usually the same as
            nodes in our project.
            demandVals, a list of the demand at each node. It is usually
            all 1.
            weightVals, a list of the weight between nodes. It is a 1d list.
        Output: m, the solved model
                x, the nodes that are selected as bases
                y, y[i,j] means that node i is subject to parition j
    """
    #Model
    m = gurobipy.Model('p-median_modified')
    
    #Params
    demand = dict(zip(nodes,demandVals))
    combs = [(x,y) for x in nodes for y in baseSet] #A list of tuples of all 
                                                    #possible combinations 
                                                    #between x and y
    temp2, dist = gurobipy.multidict(zip(combs,distVals))
    temp1, prob = gurobipy.multidict(zip(nodes,probVals))
    
    n = len(nodes)
    
    #Variables
    y = m.addVars(combs, name = 'y', vtype=gurobipy.GRB.BINARY) #Whether node 
                                                                #is subject to base j
    x = m.addVars(baseSet, name = 'x', vtype=gurobipy.GRB.BINARY) #Whether node j
                                                                  #is a base
    # Tc = 1/partitionDist
#    partitionDist = m.addVars(baseSet, name = 'partitionDist', 
#                              vtype = gurobipy.GRB.CONTINUOUS)
    
    freq = m.addVars(baseSet, name = 'freq', 
                              vtype = gurobipy.GRB.CONTINUOUS)

    # Convert the objective function to non-negative to remove the square term    
    diffp = m.addVars(baseSet, name = 'objp', lb=0.0, ub=gurobipy.GRB.INFINITY,
                          vtype = gurobipy.GRB.CONTINUOUS)
    
    diffn = m.addVars(baseSet, name = 'objn', lb=0.0, ub=gurobipy.GRB.INFINITY,
                      vtype = gurobipy.GRB.CONTINUOUS)

    workload = m.addVars(baseSet, name = 'workload', lb=0.0, ub=gurobipy.GRB.INFINITY,
                      vtype = gurobipy.GRB.CONTINUOUS)
    
    epsilon = m.addVars(baseSet, name = 'helper', lb=0.0, ub=gurobipy.GRB.INFINITY,
                      vtype = gurobipy.GRB.CONTINUOUS)
    
    #Objective
    
 #   expr = gurobipy.quicksum(dist[i,j]*y[i,j] for i in nodes for j in baseSet)

    exprNew = gurobipy.quicksum((1/n) * (freq[j]*workload[j] - 
                               (1/n)* gurobipy.quicksum(freq[k]*workload[k] for k in baseSet)) for j in baseSet)
    
#    partitionList = []
#    for i in baseSet:
#        subList = list([]);
#        for j in nodes:
#            #Unable to access the y values during optimization
#            if y[i,j].getAttr("x") == 1:
#                subList.append(j)
#        partitionList.append(subList)
#    
#    partitionDistExprList = []
#    for i in range(len(partitionList)):
#        partitionDistExprList.append(findTotalDistToCentroid(partitionList[i], nodeCoords))
#        
    #Tc = 1/partitionDistExpr
    #Tc = 1
    #epsilon = (gurobipy.quicksum(1/Tc * weight[i,j]*y[i,j] for j in nodes) for i in baseSet)
    
    #m.setObjective(exprNew, gurobipy.GRB.MINIMIZE)
    
    #Constraints
    c1 = m.addConstrs((y.sum(i, '*') == 1 for i in nodes), "c1")
    c2 = m.addConstr(x.sum(), gurobipy.GRB.EQUAL, baseNum, "c2")
    c3 = m.addConstrs((y[i,j] <= x[j] for i in nodes for j in baseSet), "c3")
    # c4 is a quadratic equality constraint, which is not convex and thus cannot be solved.
    c4 = m.addConstrs(( gurobipy.quicksum(dist[i,j]*y[i,j] for i in nodes) * freq[j] == 1 for j in baseSet) , "freqConstraintp")
    c5 = m.addConstrs(( workload[j] == gurobipy.quicksum(prob[i] * y[i,j] for i in nodes) for j in baseSet) , "workloadConstraint")
#    c6 = m.addConstrs((diffp[j] - diffn[j] ==  freq[j]*workload[j] - (1/n)* gurobipy.quicksum(freq[k]*workload[k] for k in baseSet) for j in baseSet), "artificial")
#    c7 = m.addConstrs((epsilon[j] == freq[j]*workload[j] for j in baseSet), 'epsilonConstraint')
    
    m.optimize()
    
    return m,x,y


def p_median_original(nodes, baseSet, baseNum, demandVals, weightVals):
>>>>>>> more gurobi
    """Solves the p-median problem using the Gurobi solver. 
        Input:  nodes, a list of all nodes
            baseSet, a list of potential bases. It is usually the same as
            nodes in our project.
            demandVals, a list of the demand at each node. It is usually
            all 1.
            weightVals, a list of the weight between nodes. It is a 1d list.
        Output: m, the solved model
                x, the nodes that are selected as bases
                y, y[i,j] means that node j is subject to base node i
    """
    #Model
<<<<<<< HEAD
    m = gurobipy.Model('p-median')
=======
    m = gurobipy.Model('p-median_original')
>>>>>>> more gurobi
    
    #Params
    demand = dict(zip(nodes,demandVals))
    combs = [(x,y) for x in nodes for y in baseSet] #A list of tuples of all 
                                                    #possible combinations 
                                                    #between x and y
    temp, weight = gurobipy.multidict(zip(combs,weightVals))
    
    #Variables
    y = m.addVars(combs, name = 'y', vtype=gurobipy.GRB.BINARY) #Whether node 
                                                                #is subject to base j
    x = m.addVars(baseSet, name = 'x', vtype=gurobipy.GRB.BINARY) #Whether node j
                                                                  #is a base
    
    #Objective
    expr = gurobipy.quicksum(demand[i]*weight[i,j]*y[i,j] for i in nodes for j in baseSet)
    m.setObjective(expr, gurobipy.GRB.MINIMIZE)
    
    #Constraints
    c1 = m.addConstrs((y.sum(i, '*') == 1 for i in nodes), "c1")
    c2 = m.addConstr(x.sum(), gurobipy.GRB.EQUAL, baseNum, "c2")
    c3 = m.addConstrs((y[i,j] <= x[j] for i in nodes for j in baseSet), "c3")
    
    m.optimize()
    
    return m,x,y

<<<<<<< HEAD
def find_central_node(nodes, baseSet, demandVals, weightVals):
=======

def find_central_node(nodes, baseSet, demandVals, distVals):
>>>>>>> more gurobi
    """This function solves the 1-median problem, a special case of the p-median
        problem when the baseNum is 1. Given a set of nodes, it finds the node
        that minimizes the total cost to cover all the nodes and demands if an 
        agent use that node as the base,
        Input:  nodes, a list of all nodes
                baseSet, a list of potential bases. It is usually the same as
                nodes in our project.
                demandVals, a list of the demand at each node. It is usually
                all 1.
                weightVals, a list of the weight between nodes. It is a 1d list.
    """
    #Call the more general p-median algorithm.
<<<<<<< HEAD
    m,x,y = p_median(nodes, baseSet, 1, demandVals, weightVals)
=======
    m,x,y = p_median_original(nodes, baseSet, 1, demandVals, distVals)
>>>>>>> more gurobi
    #Extract data from the model
    xoutDict = m.getAttr('X',x)
    for key in xoutDict:
        if xoutDict[key] == 1:
            currBase = key
    return currBase