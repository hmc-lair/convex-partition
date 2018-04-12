%% Our Own Nodes

% Initialize our nodes
n_Nodes = 6;
%nodesCoord = zeros(n_Nodes, 2);
%nodesProb = zeros(n_Nodes, 1);
%nodesNames = zeros(n_Nodes, 1);
nodesNames = (1:n_Nodes)';
nodesCoord = rand(n_Nodes,2);
nodesProb = rand(n_Nodes,1);
nodesProb = nodesProb/sum(nodesProb); %Normalize to 1

testProb = [0.25,0.25,0.25,0.25,0.25,0.25]';
testCoord = [0.1,0.4;
            0.8,0.5;
            0.2,0.6;
            0.5,0.6;
            0.4,0.5;
            0.78,0.1];

nodes = [testCoord, testProb, nodesNames];

dmatrix = calculate_distance_matrix_shark_1(nodes, 0.5);

% Format the matrix to compute the line intersection
[A1,A2] = getIntersectionTestInput(nodes);
XY1 = A1(:,1:4);
XY2 = A2(:,1:4);

% Initialize outputs
diagA = zeros(size(XY1,1),1);
crossPointX = zeros(size(XY1,1),1);
crossPointY = zeros(size(XY1,1),1);

%% Computing.
tic

for i = 1:size(XY1)
    % Calculate
    out = lineSegmentIntersect(XY1(i,:),XY2(i,:));
    % Store whether two edges intersect
    diagA(i) = out.intAdjacencyMatrix;
    % Store the location of the intersection
    crossPointX(i) = out.intMatrixX;
    crossPointY(i) = out.intMatrixY;
end

dt_1 = toc;

fprintf(1,'Edge intersections of %.0f nodes took %.2f seconds to find.\n',...
    n_Nodes,dt_1);

%% Extract Outputs
% Zero means no intersection, we remove them
diagA = find(diagA);

% Zero means no intersection, we remove them
crossPointX = crossPointX(crossPointX~=0);
crossPointY = crossPointY(crossPointY~=0);

% Find the actual pairs of edges that do intersect
crossEdges1 = A1(diagA,:);
crossEdges2 = A2(diagA,:);

%% Plot Intersecting line segements and points

figure('Position',[10 100 500 500],'Renderer','zbuffer');
plot(nodes(:,1)',nodes(:,2)','o');
hold on;
line([crossEdges1(:,1)';crossEdges1(:,3)'],[crossEdges1(:,2)';crossEdges1(:,4)'],'Color','k');
line([crossEdges2(:,1)';crossEdges2(:,3)'],[crossEdges2(:,2)';crossEdges2(:,4)'],'Color','k');
scatter(crossPointX, crossPointY);
hold off;


%% Store the label of the intersecting edges
crossIndex1 = crossEdges1(:,5:6);
crossIndex2 = crossEdges2(:,5:6);
crossIndex = [crossIndex1, crossIndex2];

values = zeros(size(crossIndex1, 1),2);
values(1,:) = crossIndex1(1,:);


E1 = [crossIndex1,crossIndex2(:,1)];
E2 = [crossIndex1,crossIndex2(:,2)];

currVal = crossIndex1(1,:);
indices = zeros(size(unique(crossIndex1, 'rows')), 1);
indices(1) = 1;

for i = 1:size(crossIndex1, 1)
    if crossIndex1(i,:) ~= currVal
        currVal = crossIndex1(i,:);
        indices(i) = i;        
    end
end

