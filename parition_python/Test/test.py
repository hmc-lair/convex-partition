# -*- coding: utf-8 -*-
"""
Created on Mon Jan 22 01:10:34 2018

Based on test2 in AMPL folder in convex optimization

@author: lenovo
"""

from gurobipy import *


nodes = ['i1','i2','i3','i4','i5','i6','i7','i8','i9','i10','i11','i12']
potentialBases = ['j1','j5','j6','j8', 'j10', 'j11']

#Params
weight = []
demand = []
baseNum = 2


demandVals = [100, 90, 110, 120, 80, 100, 95, 75, 110, 90, 120, 85]
demand = dict(zip(nodes,demandVals))
weightVals = [0,	17,	23,	18,	14,	8,
              5,	17,	20,	22,	18,	13,
              11,	9,	12,	17,	13,	10,
              17,	8,	6,	17,	13,	10,
              17,	0,	7,	9,	5,	11,
              23,	7,	0,	15,	12,	18,
              21,	8,	5,	10,	7,	13,
              18,	9,	15,	0,	4,	10,
              15,	13,	20,	7,	8,	7,
              14,	5,	12,	4,	0,	6,
              8,	11,	18,	10,	6,	0,
              7,	10,	16,	13,	9,	6]

#Create a list of tuples of all possible combinations between x and y
combs = [(x,y) for x in nodes for y in potentialBases]

temp, weight = multidict(zip(combs,weightVals))

#Model
m = Model('test')

#Variables
y = m.addVars(combs, name = 'y', vtype=GRB.BINARY) #Whether node is subject to base j
x = m.addVars(potentialBases, name = 'x', vtype=GRB.BINARY)#Whether node j is a base

#Objective
expr = quicksum(demand[i]*weight[i,j]*y[i,j] for i in nodes for j in potentialBases)
m.setObjective(expr, GRB.MINIMIZE)

#Constraints
c1 = m.addConstrs((y.sum(i, '*') == 1 for i in nodes), "c1")
c2 = m.addConstr(x.sum(), GRB.EQUAL, baseNum, "c2")
c3 = m.addConstrs((y[i,j] <= x[j] for i in nodes for j in potentialBases), "c3")

m.optimize()