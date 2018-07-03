function [partition_assignment_result, adj_mat, dt] = ga_optimize(x,y,prob,T, num_partitions,penalty)
%GA_OPTIMIZE Helper function to run the genetic algorithm optimization.
N = size(x,1);
node_numbers = [1:N]';

% generate planar graph
dt = delaunayTriangulation(x,y);
A = sparse(dt.ConnectivityList, dt.ConnectivityList(:, [2:end 1]), 1);
g = graph(A + A');
plot(g, 'XData', dt.Points(:, 1), 'YData', dt.Points(:, 2));

% generate adjacency matrix
adj_mat = adjacency(g);

% The partition_assignment vector is a vector with length N=number of nodes
target_func = @(partition_assignment)...
    fitness_func(x,y,prob,partition_assignment,node_numbers,adj_mat,T,num_partitions, penalty);

% The partition assignment vector contains all the free variables that the
% genetic algorithm can modify. The constraints on these variables will be
% integer constraints: the assigned partition number needs to be smaller 
% than (or equal to) the number of partitions, and it needs to be integer.
A = [];
b = [];
lb = ones(N,1);
ub = repmat(num_partitions,N,1);
nonlcon = [];
IntCon = 1:N;
partition_assignment_result = ga(target_func,N,A,b,[],[],lb,ub,nonlcon,IntCon);
partition_assignment_result = partition_assignment_result.';

plot_partitions(g,dt,prob,partition_assignment_result)

end

