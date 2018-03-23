function [ nodes ] = generateRandomNodes( x_bounds, y_bounds, ...
    num_nodes)
%GENERATERANDOMNODES Given boundary for x and y coordinates and the number
%of nodes, generate the nodes at different x y locations with probabilities
%sum up to 1

nodes = zeros(num_nodes,3);

probs = rand(num_nodes,1);
probs = probs./sum(probs);

x = rand(num_nodes,1);
x = x_bounds(1) + rand(num_nodes,1).*(x_bounds(2)-x_bounds(1));

y = rand(num_nodes,1);
y = y_bounds(1) + rand(num_nodes,1).*(y_bounds(2)-y_bounds(1));

nodes = [x y probs];

end

