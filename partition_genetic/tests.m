initialize;

% Case 1: 4 points with equal probability
x = [1;1;3;3];
y = [1;2;1;2];
T = 1;
prob = [0.25;0.25;0.25;0.25];
num_partitions=2;
penalty = 1e10;

%[partition_assignment_result] = ga_optimize(x,y,prob,T, num_partitions,penalty);

% Case 2: random with equal probabilities
rng default
num_nodes = 15;
x = randn(num_nodes,1)*5;
y = randn(num_nodes,1)*5;
T = 1;
prob = abs(randn(num_nodes,1));
prob = prob ./ sum(prob);
num_partitions=2;
penalty = 1e10;

[partition_assignment_result, adj_mat, dt] = ga_optimize(x,y,prob,T, num_partitions,penalty);

% Create the subgraphs for each partition using the originally connected
% adjacency matrix
partition_indices = {};
for i=1:num_partitions
    partition_indices{i} = find(partition_assignment_result == i);
end

partition_adj_matrices = {};
partition_points = {};
for i=1:num_partitions
    cindx = partition_indices{i};
    partition_adj_matrices{i} = adj_mat(cindx,cindx);
    partition_points{i} = [x(cindx,:), y(cindx,:)];
end

% Plot the subgraphs (no more connection between partitions)
figure; hold on;
for i=1:num_partitions
    cgraph = graph(partition_adj_matrices{i});
    plot(cgraph, 'XData', dt.Points(partition_indices{i}, 1), 'YData', dt.Points(partition_indices{i}, 2));
end


% TSP!
% Method 1: tsp_ga.m 
for i=1:num_partitions
    % Try TSP on the first partition
    [dist, next] = fake_complete_graph(partition_adj_matrices{i}, ...
                                         partition_points{i});

    userConfig = struct('xy',partition_points{i}, 'dmat', dist,'SHOWRESULT', false);
    resultStruct = tsp_ga(userConfig);
end

% Method 2: tsp_sa.m
for i=1:num_partitions
    % Try TSP on the first partition
    [dist, next] = fake_complete_graph(partition_adj_matrices{i}, ...
                                         partition_points{i});
                                     
    [best_fitness,best_solution] = tsp_sa(dist, partition_points{i});
    plot_tour(best_solution, partition_points{i}, sprintf('After simulated annealing %0.6g', best_fitness));
end
