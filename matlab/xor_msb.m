function [y] = XOR_MSB(p, q)
%% Determine the relative order of two points by finding the the first
% differing bit with the highest exponent
%
p_parts = decompose_float(p);
q_parts = decompose_float(q);

mp_d = p_parts.MANTISSA;
mq_d = q_parts.MANTISSA;

l_type = 'uint64';
d_type = 'double';

mp_l = typecast(mp_d, l_type);
mq_l = typecast(mq_d, l_type);

xp = p_parts.EXPONENT;
xq = q_parts.EXPONENT;

% is a mask to flip all bits corresponding to 0 exponent
% It is 0011111111100100000000000000000000000000000000000000000000000000
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
        % Otherwise, XOR mantissa and calculate new exponents
        % NOTE: we OR in the zero value so we can decompose using frexp 
        %       an additional time, getting the EXPONENT of difference
        mp_l = bitor(bitxor(mp_l, mq_l), lzero_l);
        vn_d = typecast(mp_l, d_type);
        new_parts = decompose_float(vn_d - lzero_d);
        y = xp + new_parts.EXPONENT;
    end
else 
    y = xp; 
end
end

% Test this pattern: 
%nodes = [ 0 0; 0 1; 0 2; 0 3; 0 4; 1 0; 1 1; 1 2; 1 3; 1 4; 2 0; 2 1; 2 2; 2 3; 2 4; 3 0; 3 1; 3 2; 3 3; 3 4; 4 0; 4 1; 4 2; 4 3; 4 4; 5 0; 5 1; 5 2; 5 3; 5 4; 5 5; 0 5; 1 5; 2 5; 3 5; 4 5]