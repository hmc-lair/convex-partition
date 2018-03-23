function [ nodes ] = multipolygrid(node_space, varargin )

nodes = polygrid(varargin{1}, varargin{2}, node_space);

for i=3:2:size(varargin,2)
    nodes = [nodes; polygrid(varargin{i}, varargin{i+1}, node_space)];
end

end

