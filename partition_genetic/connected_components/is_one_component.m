function result = is_one_component(adj_mat)
%IS_ONE_COMPONENT Use DFS to figure out whether the provided adjacency
%matrix represents a graph with one connected component.

% create a visited array
visited = zeros(1,size(adj_mat,1));

% call dfs_util on the visited array
visited = dfs_util(adj_mat, 1, visited);

% if the visited ends up being all ones, then the entire graph is one huge
% connected component
if sum(visited) == size(adj_mat,1)
    result = true;
else
    result = false;
end
end

% helper function for recursive DFS
function visited_result = dfs_util(adj_mat, start_vertex, visited)

visited(start_vertex) = 1;

for j=1:size(adj_mat,1)
    if (visited(j) == 0 && adj_mat(start_vertex,j) == 1)
        visited = dfs_util(adj_mat, j, visited);
    end
end

visited_result = visited;

end

