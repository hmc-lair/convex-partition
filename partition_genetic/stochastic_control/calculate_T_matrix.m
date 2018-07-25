function [T] = calculate_T_matrix(p, p_des, occupied_nodes, num_nodes, ...
    K_struct)
% CALCULATE_T_MATRIX Calculate the transition matrix based on Andrew's
% formulation

T = zeros(num_nodes, num_nodes);
e = p_des - p;

Ka = K_struct.Ka;
Kc = K_struct.Kc;
Kd = K_struct.Kd;

p_max = 1;
p_min = 1- p_max;

for i = 1:num_nodes
    
    if i - 1 <=  0
        j = num_nodes;
    else
        j = i-1;
    end
   
    if i+1 > num_nodes
        k = mod(i+1, num_nodes);
    else
        k = i+1;
    end
    
    if ismember(k, occupied_nodes)
        % next node is occupied, so we need to stay at current node
        T(i, i) = 1;
    else
        if ismember(j, occupied_nodes)
            % previous node is occupied
            T(i, i) = (1/(1-p(1,k)))*(1- p(1, k) + (1/p(1, i))*(Ka*e(1, i) + (1/p(1, j))*Kc*(-e(1, k) + e(1, j))));
        else
            T(i, i) = (1/(1-p(1,k)))*(1- p(1, k) + (1/p(1, i))*(Ka*e(1, i)));
        end
    end
    T(i, i) = max(min(T(i, i), p_max), 0);
    T(i,k) = 1 - T(i,i); % T(i,k) + T(i,i) needs to be equal to 1
end


