function [symrcm_bandwidth, r] = symrcm_stencils(stencil_list)
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

r = symrcm(A);

[ii,jj] = find(A(r,r));
symrcm_bandwidth = max(abs(ii-jj))

hold off;
delete(gca);
spy(A(r,r), '.');
axis('square');

end