% Objective
numNodes = 4;
numPartition = 2;
v = 1; 
r = 1;
Tnode = 2*pi*r/v; %Time spent to circle around a node.

nodes_x = [1; 5; 2; 5];
nodes_y = [4; 2; 3; 5];
nodes_fish = [30; 10; 10; 30];
nodes_prob = nodes_fish./sum(nodes_fish);

xtype = 'B';
xtype = repmat(xtype, [1, numNodes*numPartition]);

%b0 = 1;
%b0 = repmat(b0, [1, numNodes*numPartition]);
% b0_Matrix = [0 1;
%              1 0;
%              0 1;
%              0 1];

b0_Matrix = generateRandomPartition(numNodes, numPartition);

b0 = reshape(b0_Matrix, 1, []);

% Set both upper and lower bounds to 1 so that it is essentially equality
cl = repmat(1, [1, numNodes]);
cu = repmat(1, [1, numNodes]); 

%https://www.mathworks.com/help/optim/ug/passing-extra-parameters.html
objWrapper = @(x)objFun(x,numNodes, numPartition, Tnode, nodes_x, nodes_y, nodes_prob);
consWrapper = @(x)addDecisionVars(x, numNodes, numPartition);

opts = optiset('display','iter', 'warnings', 'all');
Opt = opti('fun', objWrapper, 'nl', consWrapper, cl, cu, 'xtype',xtype, 'options',opts);
[partitionOut,fval,exitflag,info] = solve(Opt,b0); 

partitionOut = reshape(partitionOut, [numPartition, numNodes])'; 
disp(partitionOut);

function [decisionSum] = addDecisionVars(bvec, numNodes, numPartition)
% This function adds every numPartition bvec together. This later ensures
% that each node can only be assigned to one partition.

%Reshape the matrix so that each row consists of the binary decision
%variables for one same node.

b = reshape(bvec, [numPartition, numNodes])';  
decisionSum = sum(b,2); %Compute the sum along rows

end


function [obj] = objFun(bvec ,numNodes, numPartition, Tnode, nodes_x, nodes_y, nodes_prob)


% nodes_x = [1; 1; 5];
% nodes_y = [0; 4; 2];
% nodes_fish = [10; 10; 20];
% nodes_prob = nodes_fish./sum(nodes_fish);

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

obj = (1/numNodes) * var(epsilonVec);

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