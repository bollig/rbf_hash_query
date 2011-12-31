function [output_ind] = ijk_to_x(ijk_ind, dims, boundingBox)
%% Equations 57, 58 from Stocco and Schrack 2009
I = ijk_ind(:,1)-1; 
J = ijk_ind(:,2)-1; 
K = ijk_ind(:,3)-1;

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