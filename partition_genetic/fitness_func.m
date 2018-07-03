function [result] = fitness_func(x,y,prob,partition_assignment,node_numbers,adj_mat,T,num_partitions, penalty)
%FITNESS_FUNC The fitness function used in the genetic algorithm
% Let the number of nodes be N.
% x: N-by-1 vector indicating the x coordinates of each of the nodes
% y: N-by-1 vector indicating the y coordinates of each of the nodes
% prob: N-by-1 vector indicating the probability of fish sighting at each
%       of the nodes
% partitions_assignment: N-by-1 vector indicating the assignment of each of
%                        the node to each partition
% num_partitions: the number of partitions 
% adj_mat: the adjacency matrix of the graph
% node_numbers: the index of each node in the graph. This needs to
% correspond to the adjacency matrix.
%
% The fitness function is the following:
% 
% 
% The pseudocode of the function is the following:
% 1. Based on the partition assignment of each of the node, create a
% non-scalar struct to hold the nodes' x,y,prob for each partition
% 2. For each partition calculate the relevant loads
% 3. Calculate the final scalar value
%
% Notice that partition_assignment is the free variable for optimization.

% create partitions
result = 0;
partitions = struct('x',{},'y',{},'prob',{});

for i=1:num_partitions
    cidx = (partition_assignment == i);
    partitions(i).x = x(cidx);
    partitions(i).y = y(cidx);
    partitions(i).prob = prob(cidx);
    partitions(i).nodes = node_numbers(cidx);
end

% calculate frequencies for each partition
partitions_freqs = zeros(num_partitions,1);
for i=1:num_partitions
    % calculate the sum of probabilities in these partitions
    prob_sum = sum(partitions(i).prob);
    
    % calculate the load
    midx = mean(partitions(i).x); % geometric center
    midy = mean(partitions(i).y);
    cload = sum(sqrt((partitions(i).x-midx).^2 + (partitions(i).y-midy).^2)) + T*size(partitions(i).x,1);
    
    % check for adjancies: whether the partition is connected using the
    % original adjaceny matrix
    partition_adj_mat = adj_mat(partitions(i).nodes, partitions(i).nodes);
    % ///////////////////////////////////////////////////
    % THE BELOW PART USES MATLAB'S CONNCOMP
    % partition_graph = graph(partition_adj_mat);
    % connect_components = conncomp(partition_graph, 'OutputForm', 'cell');
    % if size(connect_components,2) > 1 % if the number of components is more than 1
    %     result = result + penalty;
    % end
    %///////////////////////////////////////////////////
    
    % THE BELOW PART USES THE DFS METHOD
    if ~is_one_component(partition_adj_mat)
        result = result + penalty;
    end
    
    partitions_freqs(i) = prob_sum/cload;
end

% calculate mean frequencies
mean_freq = mean(partitions_freqs);

% calculate final result
result = result + 1/num_partitions * sum((partitions_freqs - mean_freq).^2);

end

