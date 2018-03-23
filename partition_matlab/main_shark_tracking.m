% Test the partition on 

nodes = zeros(5,3);
nodes(1,:) = [0 0 1];
nodes(2,:) = [0 2 1];
nodes(3,:) = [1 1 96];
nodes(4,:) = [2 0 1];
nodes(5,:) = [2 2 1];

dmatrix = calculate_distance_matrix_shark_1(nodes, 0.5);

%Format the matrix to compute the line intersection
expandedNodes = repmat(nodes, size(nodes,1), 1);
expandedNodesCoord1 = expandedNodes(:,1:2);
expandedNodesCoord2 = expandedNodes(:,1:2);


cost = ones(5,1);

write_p_median_with_distance_matrix(...
    dmatrix, cost, 2, 'ampl/shark_1.dat');

% AMPL interfacing
addpath('C:\Users\Jingnan Shi\Downloads\ampl_mswin64\amplapi\matlab');
setUp;
ampl = AMPL;
ampl.read('ampl/p-Median.mod');
ampl.readData('ampl/shark_1.dat');
ampl.eval('option solver cplex;');

p = ampl.getParameter('p');
p.setValues(2);

ampl.solve;

x = ampl.getData('{j in J} x[j]');
bases = getBases(x);

partitions = getPartitions(ampl, bases);

plotPartitions(nodes, bases, partitions);
