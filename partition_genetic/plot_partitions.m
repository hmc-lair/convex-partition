function plot_partitions(g,dt,prob,partition_assignment)
%PLOT_PARTITIONS plot the nodes with partitions
%figure;
%scatter(x, y, abs(prob).*200, partition_assignment,'filled') 
figure;
p = plot(g, 'XData', dt.Points(:, 1), 'YData', dt.Points(:, 2));
p.NodeCData = partition_assignment';
p.NodeLabel = prob';
end

