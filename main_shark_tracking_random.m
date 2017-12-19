nodes = generateRandomNodes([0 10], [0 10], 200);

dmatrix = calculate_distance_matrix_shark_1(nodes, 0.5);

cost = ones(1000,1);

write_p_median_with_distance_matrix(...
    dmatrix, cost, 2, 'ampl/test.dat');

% AMPL interfacing
addpath('C:\Users\Jingnan Shi\Downloads\ampl_mswin64\amplapi\matlab');
setUp;
ampl = AMPL;
ampl.read('ampl/p-Median.mod');
ampl.readData('ampl/test.dat');

ampl.eval('option solver gurobi_ampl;');
ampl.eval('option gurobi_options ''outlev 1'';');

p = ampl.getParameter('p');
p.setValues(2);

ampl.solve;

x = ampl.getData('{j in J} x[j]');
bases = getBases(x);

partitions = getPartitions(ampl, bases);

plotPartitions(nodes, bases, partitions);
