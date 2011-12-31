function [output_ind] = ijk_to_x(ijk_ind, dims, boundingBox)
%% Producesthe O_X-Order
I = ijk_ind(:,1)-1; 
J = ijk_ind(:,2)-1; 
K = ijk_ind(:,3)-1;

%% We dont want more than 1 neighbor in the same dimension before switching
%% to other dimensions
edge = 1;

if (dims < 2)
    output_ind = ijk_ind(:,1); 
else
    X = dilate(I, edge^(dims-1), edge);
    Y = dilate(J, edge^(dims-1), edge);
    if (dims > 2)
       Z = dilate(K, edge^(dims-1), edge);
       output_ind = bitor(bitor(bitshift(X,edge^(dims-1)), bitshift(Y,edge^(dims-2))), Z) + 1;  
    else 
       output_ind = bitor(  bitshift( bitxor(X,Y) , edge^(dims-1))   , Y) + 1; 
    end
end
end