function [best_fitness,best_solution] = tsp_sa(adj_mat, dmat, points)
%TSP_SA Use simulated annealing to solve the traveling salesman problem
%
% See: https://github.com/chncyhn/simulated-annealing-tsp/blob/master/anneal.py
% http://www.theprojectspot.com/tutorial-post/simulated-annealing-algorithm-for-beginners/6

rng('default')

% Some parameters for setup
N = size(points,1);
T = sqrt(N);
alpha = 0.995;
stopping_temperature = 0.000001;
stopping_iter = 10000;

iterations = 1;
nodes_idx = [1:N]';
c_solution = tsp_sa_initial_solution(adj_mat, dmat);
best_solution = c_solution;

initial_fitness = tsp_sa_fitness(c_solution, dmat);
c_fitness = initial_fitness;
best_fitness = c_fitness;

fitness_list = [c_fitness];

% Annealing
while T >= stopping_temperature && iterations < stopping_iter
    candidate = c_solution;
    l = randi([3, N-1]);
    i = randi([1, N-1]);
    candidate(1, i:(i+l)) = fliplr( candidate(1, i:(i+l)) );
    
    % TODO: Check acceptance
    candidate_fitness = tsp_sa_fitness( candidate, dmat );
    if candidate_fitness < c_fitness
        c_fitness = candidate_fitness;
        c_solution = candidate;
        if c_fitness < best_fitness
            best_fitness = candidate_fitness;
            best_solution = candidate;
        end
    else
        p_accept = exp(-abs( candidate_fitness - c_fitness ) / T);
        if rand(1) < p_accept
            c_fitness = candidate_fitness;
            c_solution = candidate;
        end 
    end
    
    T = T * alpha;
    iteration = iteration + 1;
    fitness_list = [fitness_list, c_fitness];
end

end
