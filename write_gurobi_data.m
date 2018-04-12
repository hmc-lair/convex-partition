function [output] = write_gurobi_data(nodes, dmatrix, crossIndex,...
                                      filename)
% nodes [xcoord,ycoord,prob,index]
% dmatrix[i,j] weight of edge ij
% crossIndex[a,b,c,d] edge ab intersects with edge cd

fileID = fopen(filename,'w');

fprintf(fileID, ', j%d', col);
end