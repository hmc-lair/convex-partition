set I; #All nodes
set J; #Set of potential bases

#For edge{I,J}, which edges intersect with them.

#set E1{I,J} within {I,J} ordered;
#set E2{I,J} within {I,J} ordered;


param d{I,J};
param h{I}; #Demand at node i
param p; #Number of AUVs

# whether edge i,j is being selected
var y{I,J} binary; # whether node i is subject to partition j
var x{J} binary; # whether node j is a base

minimize totalCost:
  sum{i in I, j in J}(h[i]*d[i,j]*y[i,j]);

subject to SingleDeliveryCons{i in I}:
  sum{j in J}(y[i,j]) = 1;

subject to DeliverAllCons:
  sum{j in J}(x[j]) = p;

subject to SupplyDemandBindCons{i in I, j in J}:
  y[i,j] <= x[j];

subject to NonIntersectingPathConstraint{i in I, j in J}:
  y[i,j] + sum{a, b in E}(y[a,b]) <= 1 #E is the set of edges that intersect with
                                       #edge ij

#subject to NonIntersectingPathConstraint{i in I, j in J}:
#  y[i,j] + sum{(a,b) in E1[i,j]}( y[a,b] ) <= 1;
