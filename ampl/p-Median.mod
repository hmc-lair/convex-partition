set I; #1..12
set J; #1,5,6,8,10,11

param d{I,J};
param h{I}; #Demand at node i
param p; #Number of bases

# whether edge i,j is being selected
var y{I,J} binary;
var x{J} binary;

minimize totalCost:
  sum{i in I, j in J}(h[i]*d[i,j]*y[i,j]);
  
subject to SingleDeliveryCons{i in I}:
  sum{j in J}(y[i,j]) = 1;

subject to DeliverAllCons:
  sum{j in J}(x[j]) = p;

subject to SupplyDemandBindCons{i in I, j in J}:
  y[i,j] <= x[j];