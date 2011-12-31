function [morton_ind] = ijk_to_morton(ijk_ind, dims, boundingBox)
I = ijk_ind(:,1)-1; 
J = ijk_ind(:,2)-1; 
K = ijk_ind(:,3)-1;

if (dims < 2)
    morton_ind = ijk_ind(:,1); 
else
    %ORIG=[dec2bin(ijk_ind(:,1)), dec2bin(ijk_ind(:,2))]
    
    X = dilate(I, dims-1, 1);
    Y = dilate(J, dims-1, 1);
    %dec2bin(I)
    %dec2bin(X)
    %dec2bin(J)
    %dec2bin(Y)
    if (dims > 2)
       Z = dilate(K, dims-1, 1);
       morton_ind = bitor(bitor(bitshift(X,2), bitshift(Y,1)), Z) + 1;  
    else 
       morton_ind = bitor(bitshift(X,1),Y) + 1; 
    end
   %dec2bin(sort(morton_ind))
end
end