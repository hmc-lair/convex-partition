function plotPartitions( nodes, bases,partitions )

txt1 = {};
h = gobjects(0,0);

for i=1:size(partitions,2)
    h(end+1) = plot(nodes(bases(i),1), nodes(bases(i),2), 'o');
    txt1{end+1} = ['Center ' num2str(i)];
    hold on;
    h(end+1) = plot(nodes(partitions{:,i},1), nodes(partitions{:,i},2),'*');
    txt1{end+1} = ['Partition ', num2str(i)];
end

legend(h, txt1,'location','eastoutside')

end

