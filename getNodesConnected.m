function [ y1_row ] = getNodesConnected( y1 )

y1_num_rows = y1.getNumRows();

y1_row = [];

for i=1:y1_num_rows
    row_data = y1.getRowByIndex(i);
    if row_data{2} == 1
        % save the current node number to y1_row
        node_num_char = row_data{1};
        y1_row = [y1_row; str2num(node_num_char(2:end))];
    end
end

end

