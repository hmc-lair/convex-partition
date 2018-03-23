function [ matrix ] = calculate_distance_matrix( nodes )
%CALCULATE_DISTANCE_MATRIX Given nodes, calculate distance matrix
% nodes= x y probablity
matrix = zeros(size(nodes, 1), size(nodes,1));

for row=1:size(matrix,1)
    for col=1:size(matrix,2)
        xi = nodes(row,1);
        xj = nodes(col,1);
        yi = nodes(row,2);
        yj = nodes(col,2);
        distance = sqrt( (xi-xj)^2 + (yi - yj)^2);   
        matrix(row,col) = distance;
    end
end

end

