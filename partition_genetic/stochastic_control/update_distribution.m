function [P] = update_distribution(goal_nodes, num_nodes, num_individuals)
% Gets the distribution of populations for plotting later
P = zeros(1,num_nodes);
if num_individuals > 0
    for i=1:length(goal_nodes)
        j = goal_nodes(i);
        P(j) = P(j)+1/num_individuals;
    end
end
end