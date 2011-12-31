function [output_ind] = ijk_to_u(ijk_ind, dims, boundingBox)
%% Attempts to produce a O_U-order (Fig 9, (C)) but doesnt get then in and
%% out on the same side. The in is opposite the out corner in all dims, so
%% it looks nice. 
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
        
       % Looks close:  
       %output_ind = merge3( Y, XxorY, ZxorX );
       % IN/OUT opposite corners: output_ind = merge3( Y, ZxorY, ZxorX );
       % Fig 9 (C)        
       output_ind = merge3( Y, Z, ZxorX );
    else
        output_ind = merge2( Y, XxorY );
    end
end
end

function [out] = merge2(marg1, marg2)
    out = bitor( bitshift(marg1,1) , marg2 ) + 1;  
end

function [out] = merge3(marg1, marg2, marg3)
    out = bitor( bitor( bitshift(marg1,2) , bitshift(marg2,1) ), marg3) + 1;  
end