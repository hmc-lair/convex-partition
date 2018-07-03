%% Test the DFS method for determine the number of connected components

% a,b,d are connected; c and e are connected
% https://math.stackexchange.com/questions/1553489/finding-connected-components-of-the-graph
adj_mat = [0 1 0 0 0;
           1 0 0 1 0;
           0 0 0 0 1;
           0 1 0 0 0;
           0 0 1 0 0];  
result = is_one_component(adj_mat); % should be false

% This is the sub adjacency matrix containing only a,b,d
adj_mat_2 = adj_mat([1 2 4],[1 2 4]);
result_2 = is_one_component(adj_mat_2); % should be true