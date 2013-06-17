function [output_ind] = ijk_to_z(ijk_ind, dims)
%% Produces a O_ijk-order (Raster)
I = ijk_ind(:,1)-1; 
J = ijk_ind(:,2)-1; 
K = ijk_ind(:,3)-1;

%% We dont want more than 1 neighbor in the same dimension before switching
%% to other dimensions
edge = dims-1;

if (dims < 2)
    output_ind = ijk_ind(:,1); 
else
    if (dims > 2)
    else 

    end
    output_ind = ijk_ind
end
end
