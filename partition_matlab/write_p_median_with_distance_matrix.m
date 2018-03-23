function [ dmatrix ] = write_p_median_with_distance_matrix(...
    dmatrix, farm_cost, num_bases, filename )
%WRITE_DISTANCE_MATRIX Given nodes, write distance matrix

% write the matrix to the textfile line by line
fileID = fopen(filename,'w');

% write the set
fprintf(fileID,'set J:=');
for col=1:size(dmatrix,2)
    if col ~= 1
        fprintf(fileID, ', j%d', col);
    else
        fprintf(fileID, 'j%d', col);
    end
end
fprintf(fileID, ';\n\n');  

fprintf(fileID, 'set I:=');
for row=1:size(dmatrix,1)
    if row ~= 1
        fprintf(fileID, ', i%d', row);
    else
        fprintf(fileID, 'i%d', row);
    end
end
fprintf(fileID, ';\n\n');  

% write number of bases
fprintf(fileID, 'param p:= %d;\n\n', num_bases);

% write demand for each node
fprintf(fileID, 'param h:=');
for row=1:size(dmatrix,1)
    fprintf(fileID, ' i%d %.3f', row, farm_cost(row));  
end
fprintf(fileID, ';\n\n');  

% write the header lines
fprintf(fileID,'param d:  ');
for col=1:size(dmatrix,2)
    fprintf(fileID, 'j%d    ', col);  
end
fprintf(fileID, ' :=\n');

for row=1:size(dmatrix,1)
    fprintf(fileID, 'i%d     ', row);
    for col=1:size(dmatrix,2)
        fprintf(fileID, ' %.3f', dmatrix(row,col)); 
    end
    if row ~= size(dmatrix,1)
        fprintf(fileID, '\n');
    else
        fprintf(fileID, ';\n');
    end
end

fclose(fileID);

end

