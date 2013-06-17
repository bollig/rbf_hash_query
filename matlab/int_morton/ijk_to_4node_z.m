function [output_ind] = ijk_to_4node_z(ijk_ind, cell_props)
%% Equations 57, 58 from Stocco and Schrack 2009
%% NOTE: assumes ijk_ind start at 0
I = ijk_ind(:,1); 
J = ijk_ind(:,2); 
K = ijk_ind(:,3);

dims = cell_props.dim;

if (dims < 2)
    output_ind = ijk_ind(:,1); 
else
    X = dilate(I, 2^(dims-1), 2);
    Y = dilate(J, 2^(dims-1), 2);
    if (dims > 2)
       Z = dilate(K, 2^(dims-1), 2);
       output_ind = bitor(bitor(bitshift(X,2^(dims-1)), bitshift(Y,2^(dims-2))), Z) + 1;  
    else 
       output_ind = bitor(bitshift(X,2^(dims-1)),Y) + 1; 
    end
end
end