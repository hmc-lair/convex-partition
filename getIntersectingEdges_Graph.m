% The problem of using the graph class is that the intersection algorithm
% will treat two path ending at a same node as an intersection. However, in
% our case, we do not want this to be intersecting.
n_Nodes = 6;
A = ones(n_Nodes) - diag(ones(n_Nodes,1));
G = graph(A~=0);

G.Nodes.Names = (1:n_Nodes)';
G.Nodes.X = rand(n_Nodes,1);
G.Nodes.Y = rand(n_Nodes,1);
G.Nodes.Prob = rand(n_Nodes,1);
G.Nodes.Prob = G.Nodes.Prob / sum(G.Nodes.Prob);

G.Edges.X1 = G.Nodes.X(G.Edges.EndNodes(:,1));
G.Edges.Y1 = G.Nodes.Y(G.Edges.EndNodes(:,1));
G.Edges.X2 = G.Nodes.X(G.Edges.EndNodes(:,2));
G.Edges.Y2 = G.Nodes.Y(G.Edges.EndNodes(:,2));
G.Edges.Names = (1:size(G.Edges.X1,1))';

input = [G.Edges.X1, G.Edges.Y1, G.Edges.X2, G.Edges.Y2];
out = lineSegmentIntersect(input, input);
[a,b] = find(out.intAdjacencyMatrix);

[p1, q1] = findedge(G,a);
[p2, q2] = findedge(G,b);

figure('Position',[10 100 500 500],'Renderer','zbuffer');
plot(G.Nodes.X, G.Nodes.Y, 'o');
hold on;
line( [G.Nodes.X(p1); G.Nodes.X(q1)], [G.Nodes.Y(p1); G.Nodes.Y(q1)], 'color','k');
line( [G.Nodes.X(p2); G.Nodes.X(q2)], [G.Nodes.Y(p2); G.Nodes.Y(q2)], 'color','k');
reshapedX = reshape(out.intMatrixX, [size(out.intMatrixX,1)^2, 1] );
reshapedY = reshape(out.intMatrixY, [size(out.intMatrixY,1)^2, 1] );
scatter(reshapedX, reshapedY);
hold off;
