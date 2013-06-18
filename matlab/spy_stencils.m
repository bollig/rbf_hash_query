function [bandwidth] = spy_stencils(stencil_list)
% Show the spy(stencil_list) to see sparsity patterns
N = size(stencil_list, 1); 
st = size(stencil_list,2); 
A = spalloc(N, N, st * N);
for i = 1:N
    for j = 1:st
        A(i,stencil_list(i,j)) = 1; 
    end
end

%% Find the bandwidth of the matrix
[ii,jj] = find(A); 
bandwidth = max(abs(ii-jj))

spy(A);
%axis('square');

end