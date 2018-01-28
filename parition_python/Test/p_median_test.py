# -*- coding: utf-8 -*-
"""
Created on Fri Jan 26 01:27:01 2018

@author: lenovo
"""

# -*- coding: utf-8 -*-
"""
Created on Mon Jan 22 01:10:34 2018

Based on test2 in AMPL folder in convex optimization

@author: lenovo
"""


import gurobipy
import p_median

nodes = ['i1','i2','i3','i4','i5','i6','i7','i8','i9','i10','i11','i12']
baseSet = ['j1','j5','j6','j8', 'j10', 'j11']

#Params
baseNum = 2
demandVals = [100, 90, 110, 120, 80, 100, 95, 75, 110, 90, 120, 85]

distVals =   [0,	17,	23,	18,	14,	8,
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

m,x,y = p_median.p_median(nodes, baseSet, baseNum, demandVals, distVals)
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

#center = p_median.find_central_node(nodes, baseSet, baseNum, demandVals, distVals)
#print(center)

