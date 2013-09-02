function [rcm, r] = symrcm_stencils(stencil_list, enable_spy)

if nargin < 2
    enable_spy = 1
end

% Show the spy(stencil_list) to see sparsity patterns

N = size(stencil_list, 1); 
st = size(stencil_list,2); 
A = spalloc(N, N, st * N);
for i = 1:N
    %for j = 1:st
        A(i,stencil_list(i,1:st)) = 1; 
    %end
end

r = symrcm(A);

[ii,jj] = find(A(r,r));
rcm.bandwidth = max(abs(ii-jj))
rcm.r = r; 

if enable_spy
s = figure; 
spy(A(r,r), '.');
axis('square');
end 

end