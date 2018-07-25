%% BFS test
graph = {[2,3,4],[1],[1],[1]}; % all nodes need to start at 1

[result,steps] = shortest_tour_BFS(graph);

clear;

%% Floyd Warshall Test
graph = {[2], [3,4],[],[]};
weights = {[4], [9,6], [], []};
[dist,next] = floyd_warshall(graph, weights);
path = floyd_warshall_path(1,4,next);

clear;

%% TSP simulated annealing test
adj_mat = [0  1  0  0;
           1  0  1  1;
           0  1  0  0;
           0  1  0  0];
points = [0 0;
          4 0;
          13 0;
          4 6];
[dist, next] = fake_complete_graph(adj_mat, points);
[solution] = tsp_sa_initial_solution(dist);
[best_fitness,best_solution] = tsp_sa(dist, points);
clear;

% more random tests
rng default
num_nodes = 15;
x = randn(num_nodes,1)*5;
y = randn(num_nodes,1)*5;
points = [x,y];
dmat = zeros(num_nodes);
for i=1:num_nodes
    for j=1:num_nodes
        dmat(i,j) = sqrt(sum( (points(i,:) - points(j,:)).^2 ));
    end
end
[solution] = tsp_sa_initial_solution(dmat);
% plot the tour
plot_tour(solution, points, 'Initial');

[best_fitness,best_solution] = tsp_sa(dmat, points);
plot_tour(best_solution, points, 'After simulated annealing');
