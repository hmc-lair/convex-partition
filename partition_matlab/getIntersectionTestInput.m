function [out1, out2 ] = getIntersectionTestInput( nodes )
% Summary of this function goes here
% Given the nodes, create a matrix that is used for intersection test.
%   Detailed explanation goes here
% Nodes are in the format x, y, nodeNum, where x and y are geolocations of
% the node, nodeNum is the label of the node.

% The total number of edges in our graph is 1+2+3+...+(n-1). We use the
% arithmetic sum formula
n = size(nodes,1);
r = ((n - 1) + 1) * ((n - 1)) / 2;

% edgeCoord has the format: x1 y1 x2 y2 num1 num2, where num1 num2
% are the labels of the node
edgeCoord = zeros(r,6);

% We interate through our node list to create edges.
% We select two different nodes and record their labels and geolocations.
counter = 1;
for b = 1:size(nodes,1)
    for c = b+1:size(nodes,1)
        edgeCoord(counter,1:2) = nodes(b,1:2);
        edgeCoord(counter,3:4) = nodes(c,1:2);
        edgeCoord(counter,5) = nodes(b,end);
        edgeCoord(counter,6) = nodes(c,end);
        counter = counter + 1;
    end
end

% Manipulate the edges to find all pairs of edges that need to check
% intersection. Two edges need to check intersection only if they do not
% share any common nodes. Otherwise, by definition, they will not
% intersect.
edgeCoord2 = kron(edgeCoord,ones(size(edgeCoord,1),1));
edgeCoord3 = repmat(edgeCoord, size(edgeCoord,1), 1);

% Set the rows to zero if the rows are the same in both matrix
for b = 1:size(edgeCoord2,1)
    if isequal(edgeCoord2(b,1:2), edgeCoord3(b,1:2))...
            ||isequal(edgeCoord2(b,1:2), edgeCoord3(b,3:4))...
            ||isequal(edgeCoord2(b,3:4), edgeCoord3(b,1:2))...
            ||isequal(edgeCoord2(b,3:4), edgeCoord3(b,3:4))
        edgeCoord2(b,:) = 0;
        edgeCoord3(b,:) = 0;
    end
end

% Remove zero rows
edgeCoord2( all(~edgeCoord2,2), : ) = [];
edgeCoord3( all(~edgeCoord3,2), : ) = [];

out1 = edgeCoord2;
out2 = edgeCoord3;

end
