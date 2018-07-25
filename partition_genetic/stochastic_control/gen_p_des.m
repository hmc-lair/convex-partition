function [p_des] = gen_p_des(min_p, max_p, num_nodes)
p_des = min_p*ones(1, num_nodes);
unassigned_nodes = 1:num_nodes;

for i=1:num_nodes
    rand_node_index = int32((length(unassigned_nodes) - 1)*rand + 1);
    rand_node = unassigned_nodes(1, rand_node_index);
    unassigned_nodes(rand_node_index)= [];
    
    
    p_remain = 1- sum(p_des);
    if p_remain < min_p
        assigned_nodes_below_max = find(p_des < max_p - p_remain - min_p & p_des > min_p);
        if ~isempty(assigned_nodes_below_max)
            rand_node_index = int32((length(assigned_nodes_below_max) - 1)*rand + 1);
            rand_node = assigned_nodes_below_max(1, rand_node_index);
            p_des;
            p_des(1, rand_node) =+ p_des(1, rand_node) + p_remain;
        else
            'aa'
            assigned_nodes_below_max = find(p_des < max_p - min_p & p_des > min_p);
            p_des(1, assigned_nodes_below_max) = max_p - min_p;
        end
        break
    elseif p_remain < max_p-min_p
        if i ~= num_nodes
            rand_prob = (p_remain-min_p)*rand;
            p_des(rand_node) = p_des(rand_node) + rand_prob;
        else
            if p_des(rand_node)+ p_remain < max_p
                p_des(rand_node) = p_des(rand_node)+ p_remain;
            else
                p_des(rand_node) = p_des(rand_node)+ (max_p-min_p);
                leftover = p_remain-max_p  + min_p
                assigned_nodes_below_max = find(p_des + leftover < max_p)
                p_des(1, assigned_nodes_below_max(1, 1)) = p_des(1, assigned_nodes_below_max(1, 1)) + leftover
            end
        end

    else
        if i ~= num_nodes
            rand_prob = (max_p-min_p)*rand;
            p_des(rand_node) = p_des(rand_node) + rand_prob;
        else
            if p_des(rand_node)+ p_remain < max_p
                p_des(rand_node) = p_des(rand_node)+ p_remain;
            else
                p_des(rand_node) = p_des(rand_node)+ (max_p-min_p);
                leftover = p_remain-max_p + min_p
                assigned_nodes_below_max = find(p_des + leftover < max_p)
                p_des(1, assigned_nodes_below_max(1, 1)) = p_des(1, assigned_nodes_below_max(1, 1)) + leftover
            end
        end
    end
    

end
sum(p_des);


end

