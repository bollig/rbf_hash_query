function [] = drive_convert_order(z_order)

node_list = dlmread('ijk_nodes');
orig_stens = dlmread('ijk_stencils');

spy_stencils(orig_stens);

hnx = 10;
dim = 3;
order_func = @ijk_to_z;

% cell_hashes are a collection of bins for each cell indicating which node
% indices lie within each cell.
[cell_hashes, cell_ijk, cell_props] = lsh_overlay_grid(node_list, hnx, order_func, dim);

%% Sort our nodes according to the cell hashes. Does not sort within the
%% cells!
[sorted_hashes s_ind] = sort(cell_hashes);
sorted_nodes = node_list(s_ind,:);

spy_order(orig_stens, s_ind, z_order);

end

function [bandwidth] = spy_order(stencil_list, s_ind, z_order)

% Show the spy(stencil_list) to see sparsity patterns
s = figure; 
N = size(stencil_list, 1); 
st = size(stencil_list,2); 
A = spalloc(N, N, st * N);
for i = 1:N
    for j = 1:st
        A(i,stencil_list(i,j)) = 1; 
    end
end

if 1

% Show the spy(stencil_list) to see sparsity patterns
B = spalloc(N, N, st * N);
for i = 1:N
    for j = 1:st
        B(i,z_order.sten(i,j)) = 1; 
    end
end

%% Find the bandwidth of the matrix
[ii,jj] = find(A(s_ind,s_ind)); 
bandwidth = max(abs(ii-jj))

%%NOTE: if C is all zeros then we have successfully reordered the matrix to
%%match the original Z order. 
C = A(s_ind,s_ind) - B;
max(max(C))
end

%% Find the bandwidth of the matrix
[ii,jj] = find(A(s_ind,s_ind)); 
bandwidth = max(abs(ii-jj))

hold off;
delete(gca);
spy(A(s_ind,s_ind), '.');
axis('square');
end