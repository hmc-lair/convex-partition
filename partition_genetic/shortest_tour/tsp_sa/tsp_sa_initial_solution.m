function [solution] = tsp_sa_initial_solution(adj_mat, dmat)
%TSP_SA_INITIAL_SOLUTION Produce an initial solution for simulated
%annealing

adj_mat = full(adj_mat);

rng default;
c_node = randi([1 size(dmat,1)]);
solution = [c_node];
free_nodes = [1:c_node-1, c_node+1:size(dmat,1)];

% THE FOLLOWING RESTRICT THE TOUR TO FOLLOWING THE ADJACENCY MATRIX
% while size(free_nodes,2) > 0
%     c_neighbors = find(adj_mat(c_node,:));
%     c_neighbors_dist = dmat(c_node,:);
%     c_neighbors_dist(c_node) = inf;
%     for i=1:size(solution,2)
%         c_neighbors_dist(solution(i)) = inf;
%     end
%     
%     % find the node with the closest distance
%     [~,idx] = min(c_neighbors_dist);
%     c_node = idx;
%     free_nodes(find(free_nodes==idx)) = [];
%     solution = [solution, c_node];
% end

while size(free_nodes,2) > 0
    
    av_distances = dmat(c_node, :);

    c_best_dist = inf;
    c_next_node = -1;
    for i=1:size(av_distances,2)
        if any(i==free_nodes)
            
            c_dist = dmat(c_node, i);
            if (c_dist < c_best_dist)
                c_best_dist = c_dist;
                c_next_node = i;
            end
            
        end
    end
    free_nodes(find(free_nodes==c_next_node)) = [];
    solution = [solution, c_next_node];
end

end

