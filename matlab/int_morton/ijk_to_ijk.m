function [output_ind] = ijk_to_ijk(ijk_ind, cell_props)
%% Produces a O_ijk-order 
%% Requires ijk_ind to start at 0. 
I = ijk_ind(:,1);
J = ijk_ind(:,2);
K = ijk_ind(:,3);

output_ind = ( (I * cell_props.hny) + J ) * cell_props.hnz + K;
end