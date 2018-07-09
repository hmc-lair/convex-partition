%% BFS test
% graph = {[2,3,4],[1],[1],[1]}; % all nodes need to start at 1
% 
% [result,steps] = shortest_tour_BFS(graph);
% 
% clear;

%% Floyd Warshall Test
graph = {[2], [3,4],[],[]};
weights = {[4], [9,6], [], []};
[dist,next] = floyd_warshall(graph, weights);
path = floyd_warshall_path(1,4,next);