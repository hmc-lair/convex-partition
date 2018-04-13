iterations = 1;

% numNodes = 5;
% numPartition = 2;
% nodes_x = [1; 5; 2; 5; 3];
% nodes_y = [4; 2; 3; 5; 7];
% nodes_fish = [30; 10; 10; 30; 20];

numNodes = 6;
numPartition = 4;
nodes_x = [1;4;5;6;1;6];
nodes_y = [4;5;1;7;9;1];
nodes_fish = [40;40;70;50;30;80];
nodes_prob = nodes_fish./sum(nodes_fish);

tic
[bestPartition, bestObjVal] = findPartitions(iterations, numNodes, ... 
numPartition, nodes_x, nodes_y, nodes_prob);
toc

% Actually label each node its partition
% https://stackoverflow.com/questions/19703558/how-to-apply-a-function-to-all-rows-in-a-matrix
nodes_partition = arrayfun(@(n) find(bestPartition(n,:)), 1:size(bestPartition,1));
nodes_partition = nodes_partition';

save('nodes_x', 'nodes_x');
save('nodes_y', 'nodes_y');
save('nodes_prob', 'nodes_prob');
save('nodes_partition','nodes_partition');

fprintf('The objective function value is %d. \n', bestObjVal);


function [bestPartition, bestObjVal] = findPartitions(iterations, numNodes,...
numPartition, nodes_x, nodes_y, nodes_prob)

generatedPartitions = cell(iterations,1);
generatedObjVals = zeros(iterations,1);

for i = 1:iterations
    % Objective
    v = 1; 
    r = 0.01;
    Tnode = 2*pi*r/v; %Time spent to circle around a node.

    xtype = 'B';
    xtype = repmat(xtype, [1, numNodes*numPartition]);

    b0_Matrix = generateRandomPartition(numNodes, numPartition);
    %b0_Matrix = [1, 0; 1,0; 0,1;0,1];
    b0 = reshape(b0_Matrix, 1, []);

    % Set both upper and lower bounds to 1 so that it is essentially equality
    %cl = ones(1, numNodes);
    %cu = ones(1, numNodes);
    
    nlrhs = ones(1, numNodes);
    nle = zeros(1, numNodes);

    %https://www.mathworks.com/help/optim/ug/passing-extra-parameters.html
    objWrapper = @(x)objFun(x,numNodes, numPartition, Tnode, nodes_x, nodes_y, nodes_prob);
    consWrapper = @(x)addDecisionVars(x, numNodes, numPartition);

    opts = optiset('solver', 'bonmin', 'display','iter', 'warnings', 'all');
    Opt = opti('fun', objWrapper, 'nlmix', consWrapper, nlrhs, nle, 'xtype',xtype, 'options',opts);
    [partitionOut,fval,exitflag,info] = solve(Opt,b0); 

    partitionOut = reshape(partitionOut, [numPartition, numNodes])'; 
    generatedPartitions{i} = partitionOut;
    generatedObjVals(i) = fval;
end

bestObjVal = min(generatedObjVals);
bestPartition = generatedPartitions(generatedObjVals == bestObjVal);
bestPartition = bestPartition{1}; %Break the ties
end

function [decisionSum] = addDecisionVars(bvec, numNodes, numPartition)
% This function adds every numPartition bvec together. This later ensures
% that each node can only be assigned to one partition.

%Reshape the matrix so that each row consists of the binary decision
%variables for one same node.

b = reshape(bvec, [numPartition, numNodes])';  
decisionSum = sum(b,2); %Compute the sum along rows

end


function [obj] = objFun(bvec ,numNodes, numPartition, Tnode, nodes_x, nodes_y, nodes_prob)

% Reshape rowwise. The output is still numNodes rows and numPartition
% columns
b = reshape(bvec, [numPartition, numNodes])';

partitions = cell(1,numPartition);
nodes_x_par =  cell(1,numPartition);
nodes_y_par =  cell(1,numPartition);
nodes_prob_par = cell(1,numPartition);

for i = 1:size(partitions,2)
    nodesInside = find(b(:,i));
    partitions{i} = nodesInside;
    nodes_x_par{i} = nodes_x(nodesInside);
    nodes_y_par{i} = nodes_y(nodesInside);
    nodes_prob_par{i} = nodes_prob(nodesInside);
    
end

epsilonVec = zeros(1, size(partitions,2));

for i = 1:size(partitions,2)
    
    nodes_xi = nodes_x_par{i};
    nodes_yi = nodes_y_par{i};
    nodes_probi = nodes_prob_par{i};
    
   [centroid_xi, centroid_yi] = findCentroid(nodes_xi, nodes_yi);
    totalDist2Centroid = 0;

    for j = 1:size(nodes_xi,1)
       totalDist2Centroid = totalDist2Centroid + calcDist(nodes_xi(j), nodes_yi(j), centroid_xi, centroid_yi);
    end

    Tci = totalDist2Centroid + Tnode * size(nodes_xi,1);
    %Pi is a vector contains the probability of all nodes that is selected
    %within partition i.
    epsiloni = sum(nodes_probi)/Tci;
    epsilonVec(i) = epsiloni;
end

scale = 100;
obj = scale * (1/numNodes) * var(epsilonVec);

end


function [centroid_x, centroid_y] = findCentroid(nodes_xi, nodes_yi)

ni = max(size(nodes_xi,1), size(nodes_xi,2));
centroid_x = sum(nodes_xi)/ni;
centroid_y = sum(nodes_yi)/ni;

end

function dist = calcDist(x1, y1, x2, y2)

dist = sqrt( (x1-x2).^2 + (y1-y2).^2 );

end

function bInitial = generateRandomPartition(numNodes, numPartition)
bInitial = zeros([numNodes, numPartition]);
for i = 1:numNodes
    one_index = randi(numPartition);
    bInitial(i,one_index) = 1;
end

end

