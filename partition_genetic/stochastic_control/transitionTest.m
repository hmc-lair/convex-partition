function [trial_info] = transitionTest()
num_trials = 1;
trial_info = cell(num_trials, 5)
min_p = .01

for j=1:num_trials
    num_nodes = 5;%int32((20-3)*rand + 3)
    %{
    if num_nodes >= 9
        num_robots = int32(((9-1)-1)*rand + 1)
    else
        num_robots = int32(((num_nodes-1)-1)*rand + 1)
    end
    %}
    num_robots =2;
    occupied_nodes = 1:num_robots;

    p_des = gen_p_des(min_p, 1/double(num_robots), num_nodes);%[0.2751, 0.0489, 0.1375, 0.4934,0.0451];%[0.1391, .1257, 0.0669, 0.4957, 0.1726];%[0.1651, 0.1589, 0.0751, 0.4934, 0.1075];%
    p = zeros(1, num_nodes)
    %p_des = [.2 .2 .3 .3 0] % high error case
    %p_des = [0 0 .5 0 .5]; % broken case for single error term

    if abs(sum(p_des) - 1) > 0.01
        error("P des not equal 1")
    end

    %if p_des(p_des > 1/double(num_robots))
    %    error("P max violated")
    %end
    
    K_struct.Ka = 1000;
    K_struct.Kc = 100;
    K_struct.Kd = K_struct.Kc;

    % Loop over time
    t_max = 10000;
    window = 1000;
    for t = 1:t_max
        p(t,1:num_nodes) = update_distribution(occupied_nodes, num_nodes, num_robots);

        [m,n] = size(p);
        if m ~= 1
            if t <= window
                T = calculate_T_matrix(mean(p), p_des, occupied_nodes, num_nodes, K_struct);
            else
                T = calculate_T_matrix(mean(p(t-window:end, 1:num_nodes)), p_des, occupied_nodes, num_nodes, K_struct);
            end
        else
            T = calculate_T_matrix(p(t, 1:num_nodes), p_des, occupied_nodes, num_nodes, K_struct);
        end

        for i = 1:length(occupied_nodes)
            taus = T(occupied_nodes(i), :);
            occupied_nodes(i) = weighted_sample([1:1:length(taus)], taus);
        end

    end

    p_des
    p_avg =  mean(p(t-1000:end, 1:num_nodes))%mean(p)
    e = p_des - p_avg
    
    if all(abs(e) < 0.025)
        convergence = 1;
    else
        convergence = 0;
    end

    trial_info(j, 1:5) = {j, p_des, p_avg, e, convergence};
end
sum(cell2mat(trial_info(:, 5)))

end


