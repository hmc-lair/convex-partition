% A Collision-free Multi-AUV Path Planning System
% 
% This is the main script for generating the simulation results for the
% paper on collision free multirobot surveying.
%
% **ABBREVIATIONS** 
% - GA: Genetic Algorithm
% - SA: Simulated Annealing
% - SC: Stochastic Control
% - RNG: Random Number Generators
% - p_des: Desired probability distribution of a node/a partition/all nodes
%
% **APPROACH**
% Given a set of N nodes, each node has a probability/liklihood of finding
% fish, with M robots,
% 1. Using genetic algorithms to partition the nodes into M paprtitions
%    based on an objective function specified.
% 2. For each partition, 
%    1. Use Floyd Warshall algorithm to generate shortest distance path 
%       between every possible pair of nodes
%    2. Use the result of FW algoithm, transform the original partition
%       into complete graphs. Notice that the resulted graphs are not
%       metric (triangular inequality does not hold), therefore those 
%       graphs are not Euclidean.
%    3. Use TSP algorithms to generate a Hamilton cycle on those complete
%       graphs. 
%       1. TSP algorithms avialble:
%          1. Simulated annealing with 2-opt move
%          2. Genetic algorithm
%          3. LKH (not yet implemented/tested, available implementation
%             online)
%    4. With the closed tours, use Andrew's stochastic controller to
%       control the movements of the robots.
%       1. Each partition will have one stochastic controller running. The
%          desired p_des of each partition is the original p_des of all the
%          nodes normalized w.r.t. to the partition so that the sum equals
%          to 1.
%
% **SIMULATION SCHEME**
% To demonstrate the effectiveness of this path planning system, a
% simulation is needed. The results of such simulation can then be verified
% in real-life experiments involving robots.
% 
% The data of this simulation is a randomly-generated set of 100 nodes, 
% each node with a fish-sighting probability. The simulation will
% then run multiple iterations, and in each iteration the whole stack will
% execute. Due to the inherent randomness of the algorithms (GA + SA + SC),
% MATLAB RNG will be initialized with a fixed random seed so that the
% results are reproduceable.
%
% The aforementioned simulation will be run for different numbers of robots
% (from 1 to 10). The results will then be compiled and plotted against the 
% number of robots. The focus metrics are the following:
% 1. Rise/Convergence time: the time it takes to reach within 5% of the 
%    desired probability distribution. Notice that this desired 
%    distribution refers to the original distribution including all nodes, 
%    not the individual partition's distribution.
% 2. Distribution of workloads among robots: the standard deviation of the
%    sum of p_des allocated to each robot's partition 
% 3. Frequency/period of visit: min/max/mean time between consecutive robot
%    visits on nodes. It represents the resolution of the time series data.
%    Note that the frequency should be normalized according to the
%    p_des of that node. A simple way to do that is just multiply the time
%    by p_des (the higher probability nodes need to have a smaller
%    time to be equal to the lower probability nodes). However, it will
%    still yield useful information to look at the unnoramlized
%    time/frequency, especially the max time/lowest frequency, as it
%    provides users a way to know the lower bound of the time resolution.
%
% Author: Jingnan Shi jshi@g.hmc.edu

initialize;

% Some constants

% Create a random set of 100 nodes
% Also create the corresponding random probabilities
% Partition the nodes
% Generate complete graphs
% Generate TSP 

