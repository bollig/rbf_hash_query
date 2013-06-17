function [output_ind] = ijk_to_ijk(ijk_ind, dims)
%% Produces a O_ijk-order 
%% Requires ijk_ind to start at 0. 
I = ijk_ind(:,1)
J = ijk_ind(:,2)
K = ijk_ind(:,3)

min_i = min(I);
max_i = max(I);

min_j = min(I);
max_j = max(I);

min_k = min(I);
max_k = max(I);

output_ind = I * N;
end