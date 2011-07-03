function [y] = XOR_MSB(p, q)
%% Determine the relative order of two points by finding the the first
% differing bit with the highest exponent
%
%p_parts = decompose_float(p);
%q_parts = decompose_float(q);
%
%mp_d = p_parts.MANTISSA;
%mq_d = q_parts.MANTISSA;

[mp_d xp] = log2(p); 
[mq_d xq] = log2(q);

l_type = 'uint64';
d_type = 'double';

mp_l = typecast(mp_d, l_type);
mq_l = typecast(mq_d, l_type);

%xp = p_parts.EXPONENT;
%xq = q_parts.EXPONENT;

lzero_d = 0.5;
lzero_l = typecast(lzero_d, l_type);

% If one exponent is greater, then that exponent is the power of the msb
if (xp < xq)
    y = xq;
elseif xp == xq
    % If the exponents and mantissa are equal, the power of msb is 0
    if mp_l == mq_l
        y = 0;
    else
        display([dec2bin(mp_l);
        dec2bin(mq_l);
        dec2bin(lzero_l)])
        display(dec2bin(bitxor(mp_l, mq_l),62))
        
        % Otherwise, XOR mantissa and calculate new exponents
        mp_l = bitor(bitxor(mp_l, mq_l), lzero_l);
        display(dec2bin(mp_l))
        vn_d = typecast(mp_l, d_type); 
        %mp_l = bitxor(mp_l, mq_l);
        %new_parts = decompose_float(mp_d - lzero_d); 
        [mn_d xn] = log2(vn_d-lzero_d);
        %y = xp + new_parts.EXPONENT; 
        y = xp + xn; 
    end
else 
    y = xp; 
end
end


%nodes = [ 0 0; 0 1; 0 2; 0 3; 0 4; 1 0; 1 1; 1 2; 1 3; 1 4; 2 0; 2 1; 2 2;
%2 3; 2 4; 3 0; 3 1; 3 2; 3 3; 3 4; 4 0; 4 1; 4 2; 4 3; 4 4]