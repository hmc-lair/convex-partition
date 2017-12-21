function [ bases ] = getBases( x )

x_num_rows = x.getNumRows();
bases = [];
for i=1:x_num_rows
    row_data = x.getRowByIndex(i);
    if row_data{2} == 1
        % save the current node number to y1_row
        node_num_char = row_data{1};
        bases = [bases; str2num(node_num_char(2:end))];
    end
end

end

