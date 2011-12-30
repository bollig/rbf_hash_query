function [morton_ind] = ijk_to_morton(ijk_ind, dims, boundingBox)
if (dims < 2)
    morton_ind = ijk_ind(:,1); 
else
    
    X = dilate(ijk_ind(:,1)-1, dims-1, 1);
    Y = dilate(ijk_ind(:,2)-1, dims-1, 1);
    
    if (dims > 2)
        Z = dilate(ijk_ind(:,3), dims-1, 1);
        morton_ind = bitor(bitor(bitshift(X,2), bitshift(Y,1)), Z);  
    else 
       morton_ind = bitor(bitshift(X,1), Y);  
    end
   
end
end