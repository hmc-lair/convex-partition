# -*- coding: utf-8 -*-
"""

@author: Tianyi Ma
"""
import gurobipy

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
def p_median(nodes, baseSet, baseNum, demandVals, weightVals):
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
    m = gurobipy.Model('p-median')
    
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

def find_central_node(nodes, baseSet, demandVals, weightVals):
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
    m,x,y = p_median(nodes, baseSet, 1, demandVals, weightVals)
    #Extract data from the model
    xoutDict = m.getAttr('X',x)
    for key in xoutDict:
        if xoutDict[key] == 1:
            currBase = key
    return currBase