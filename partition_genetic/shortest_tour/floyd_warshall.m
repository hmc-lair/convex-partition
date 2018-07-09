function [dist,next] = floyd_warshall(adj_list,weights)
%FLOYD_WARSHALL Find the shortest paths between all node pairs. This
%implementation allows path reconstruction.
%
% Input:
% 1. adj_list: adjacency list of the graph (cell array); each element in
% the cell array needs to be of 1-by-N size
% 2. weights: the weights of all the edges in the adjacency list; each 
% individual weight needs to corresponds to the edge in the adj_list
%
% Output:
% 1. dist: a V-by-V distance matrix representing the shortest distance from
% one vertex to another initialized to infy
% 2. next: a V-by-V matrix of indices initialized to -1

assert(size(adj_list,1) == 1, 'Adjacency list needs to be 1-by-N');
assert(size(adj_list,2) == size(weights,2), 'Size mismatch.');
V = size(adj_list,2);

dist = inf(V);
next = -ones(V); % -1 is not going to be a node index so this is fine

dist(logical(eye(V))) = zeros(V,1); % diagonal distances = 0 (self-to-self)

for i=1:V
    c_neighbors = adj_list{i};
    c_weights = weights{i};
    
    assert(size(c_neighbors,1) == size(c_weights,1), 'Size mismatch');
    assert(size(c_neighbors,2) == size(c_weights,2), 'Size mismatch');

    if isempty(c_neighbors)
        continue;
    end
    for j=1:size(c_neighbors,2)
        dist(i,c_neighbors(1,j)) = c_weights(1,j);
        next(i,c_neighbors(1,j)) = c_neighbors(1,j);
    end
end

for k = 1:V
    for i = 1:V
        for j = 1:V
            if dist(i,j) > dist(i,k) + dist(k,j) 
               dist(i,j) = dist(i,k) + dist(k,j);
               next(i,j) = next(i,k);
            end
        end
    end
end

end