function [output_ind] = ijk_to_x(ijk_ind, dims)
%% Attempts to produce a O_X-order (Fig 9, (B)) 
I = ijk_ind(:,1)-1;
J = ijk_ind(:,2)-1;
K = ijk_ind(:,3)-1;

%% We dont want more than 1 neighbor in the same dimension before switching
%% to other dimensions
edge = dims-1;

if (dims < 2)
    output_ind = ijk_ind(:,1);
else
    Y = dilate(I, edge, 1);
    X = dilate(J, edge, 1);
    
    XxorY =  bitxor(X,Y);
    
    if (dims > 2)
        Z = dilate(K, edge, 1);
        ZxorY = bitxor(Z,Y); 
        ZxorX = bitxor(Z,X); 
        
       output_ind = interleave3( XxorY, Z, X );
    else
            %output_ind = bitor(  bitshift( bitxor(X,Y) , edge^(dims-1))   , Y) + 1; 
   
        output_ind = interleave2( XxorY, Y );
    end
end
end

function [out] = interleave2(marg1, marg2)
    out = bitor( bitshift(marg1,1) , marg2 ) + 1;  
end

function [out] = interleave3(marg1, marg2, marg3)
    out = bitor( bitor( bitshift(marg1,2) , bitshift(marg2,1) ), marg3) + 1;  
end
   