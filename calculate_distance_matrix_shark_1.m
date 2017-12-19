function [ matrix ] = calculate_distance_matrix_shark_1( nodes, lambda)
%CALCULATE_DISTANCE_MATRIX_SHARK_1 Calculate the distance matrix based on
%distance_{i,j} = lambda * 1/(Pi-Pj) + (1-lambda) * d_{i,j}
% 
% Input Parameters:
% 1. nodes: a Nx3 matrix representing nodes [x, y, probability]
% 2. lambda: a weighting parameter for the objective function

matrix = zeros(size(nodes, 1), size(nodes,1));

for row=1:size(matrix,1)
    for col=1:size(matrix,2)
        xi = nodes(row,1);
        xj = nodes(col,1);
        yi = nodes(row,2);
        yj = nodes(col,2);
        distance = sqrt( (xi-xj)^2 + (yi - yj)^2);        
        matrix(row,col) = lambda * min([1/(nodes(row,3) - nodes(col,3)) 1000])...
            + (1-lambda) * distance;
    end
end

end

