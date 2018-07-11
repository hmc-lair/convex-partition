function [result] = tsp_sa_fitness(solution,dmat)
%TSP_SA_FITNESS Fitness function for the simulated annealing solution

result = 0;
for i=2:size(solution,2)
    c_dist = dmat(solution(1,i-1), solution(1,i));
    result = result + c_dist;
end
result = result + dmat(solution(1,end), 1);

end

