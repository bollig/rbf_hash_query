function [bandwidth] = spy_stencils(stencil_list)
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
   r = symrcm(A)
   
   spy(A(r,r));
   [ii,jj] = find(A(r,r)); 
   bandwidth = max(abs(ii-jj))
   pause
end

%% Find the bandwidth of the matrix
[ii,jj] = find(A); 
bandwidth = max(abs(ii-jj))

hold off;
delete(gca);
spy(A, '.');
axis('square');

end