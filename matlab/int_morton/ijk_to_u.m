function [output_ind] = ijk_to_u(ijk_ind, cell_props)
%% Produces a O_U-order (Fig 9, (C)) 
%% Uncommont the alternates to get variations
%% Requires ijk_ind to start at 0. 
I = ijk_ind(:,1);
J = ijk_ind(:,2);
K = ijk_ind(:,3);

dims = cell_props.dim;

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
  
       % Fig 9 (C)        
       output_ind = interleave3( Y, Z, ZxorX );
       %% Uncomment this for alternate (IN/OUT opposite corners): 
       % output_ind = interleave3( Y, ZxorY, ZxorX );
       %% Here is another alternative (Looks similar): 
       %output_ind = interleave3( Y, XxorY, ZxorX );
    else
        output_ind = interleave2( Y, XxorY );
    end
end
end

function [out] = interleave2(marg1, marg2)
    out = bitor( bitshift(marg1,1) , marg2 ) + 1;  
end

function [out] = interleave3(marg1, marg2, marg3)
    out = bitor( bitor( bitshift(marg1,2) , bitshift(marg2,1) ), marg3) + 1;  
end