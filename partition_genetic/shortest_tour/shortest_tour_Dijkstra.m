function [shortest_path, steps] = shortest_tour_Dijkstra(graph, distance_graph)
%SHORTEST_PATH_DIJKSTRA Find the shortest path that goes around the graph 
% using Dijkstra
%
% Input: 
% graph - a 1*N cell array whose elements are arrays. N is the number of
% nodes.
%
% Output:
% length - the length of the shortest path
%
% We use an array of size 1-by-N to represent the state.

% Some constants
UNDEFINED = -1;

assert(size(graph,1)==1,'Graph needs to be 1-by-N');

N = size(graph,2);
expected_ans = ones(1,N); 

% Create a queue with starting states
% node_queue will be a 1-by-N struct array
for i=1:N
    temp = zeros(1,N);
    temp(i) = 1;
    node_queue(i).head = i;
    node_queue(i).visited = temp;
    node_queue(i).path = [i];
    
    % dist: for dijkstra
    dist_temp = inf(1,N);
    dist_temp(i) = 0;
    node_queue(i).dist = dist_temp;
end

% Create a cell array for storage
visited = cell(N, 2^N);
steps = 0;
shortest_path = [];

while (size(node_queue,2) ~= 0)
    s = size(node_queue,2); % size of the node queue
       
    while (s ~= 0)
        s = s - 1;
        p = node_queue(1);
        node_queue = node_queue(2:end);
        
        node = p.head;
        state = p.visited;
        cpath = p.path;
        
        state_idx = bi2de(state);
        if (all(state == expected_ans)) % all nodes have been visited
            shortest_path = cpath;
            return;
        end
        if (visited{node, state_idx} == 1)
            continue;
        end
        visited{node, state_idx} = 1;
        
        % find the connected nodes using graph
        connected_nodes = graph{node}; % an array of node indices
        for j=1:size(connected_nodes,2)
            next_node = connected_nodes(j);
            
            % create the next state
            next_state.head = next_node;
            temp = zeros(1,N);
            temp(next_node) = 1;
            next_state.visited = bitor(state, temp);
            next_state.path = [cpath, next_node];
            
            % TODO (jshi): update the distance
            
            node_queue = [node_queue, next_state];
            
        end
        
        % TODO (jshi): make sure the state with the shortest dist is at 
        % front
    end
    steps = steps + 1;
end

end

