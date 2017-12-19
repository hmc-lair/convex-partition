function [ partitions ] = getPartitions( ampl, bases )

partitions = {};

for i=1:length(bases)
    
eval_string = sprintf('{i in I} y[i, ''j%i'']', bases(i));
    
y = ampl.getData(eval_string);

y_rows = getNodesConnected(y);

partitions = cat(2,partitions,y_rows);

end

end

