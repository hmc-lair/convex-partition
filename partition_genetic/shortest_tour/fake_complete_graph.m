function [dist,next] = fake_complete_graph(adj_mat,points)
%FAKE_COMPLETE_GRAPH Turn a adjacency list with weights to a fake complete
%graph
%
% Input: 
% 1. adj_mat: adjacency matrix representation of the graph
% 2. points: (x,y) coordinates of the node points. 1st column: x; 2nd
% column: y

adj_mat = full(adj_mat);

% turn the adj_mat to an adj_list
adj_list = cell(1,size(adj_mat,1));
weights = cell(size(adj_list));

dist_func = @(i,j) sqrt(sum( (points(i,:) - points(j,:)).^2 ));

for row=1:size(adj_mat,1)
    c_neighbors = [];
    c_weights = [];
    for col=1:size(adj_mat,2)
        if adj_mat(row,col) == 1
            c_neighbors = [c_neighbors, col];
            c_weights = [c_weights, dist_func(row,col)];
        end
    end
    adj_list{row} = c_neighbors;
    weights{row} = c_weights;
end

% use floyd warshall to create a fake complete graph distance matrix
[dist, next] = floyd_warshall(adj_list, weights);

end

