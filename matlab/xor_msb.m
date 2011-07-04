function [digit] = xor_msb(p, q)
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
% It is 0011111111100000000000000000000000000000000000000000000000000000
lzero_d = 0.5;
lzero_l = typecast(lzero_d, l_type);
        
% If one exponent is greater, then that exponent is the power of the msb
% Remember: double precision says we have 11 bits (in 64bit precision) dedicated to the 
% exponent. This number is used as 2^(exp - 1023) so that no two's
% compliment is required. Therefore, negative refers to numbers < 1
% and positive exponent refers to numbers > 1. If we did a straightforward
% xor on the binary of our double numbers, the sign would be digit 0. The
% exponent would be digits 2 through 12, and the mantissa the remaining 52
% bits to complete 64bits total.

%mn_l = xor_dvals(p, q) 
% Add 12 because we have 12 digits for the sign and exponent
% similarity
%digit = find(mn_l, 1); 
%return 

if (xp > xq)
    digit = xp;
elseif xp < xq
    digit = xq; 
else 
    % If the exponents and mantissa are equal, the power of msb is 0
    if mp_l == mq_l
        % No difference, its 64 bits of similarity
        digit = 0;
    else
        % Otherwise, XOR mantissa and calculate new exponents
        % NOTE: we OR in the zero value so we can decompose using frexp 
        %       an additional time, getting the EXPONENT of difference
        %% NEW: 
        [mn_l xn] = xor_dvals(mp_d, mq_d);
        % Add 12 because we have 12 digits for the sign and exponent
        % similarity
        digit = find(mn_l, 1); 
        digit = xp+xn+find(mn_l,1);
        return 
        
        %% OLD: 
        mn_l = bitor(bitxor(mp_l, mq_l), lzero_l)
        %dec2bin(mn_l,64)
        %dec2bin(typecast(0.5, 'uint64'),64)
        vn_d = typecast(mn_l, d_type);
        new_parts = decompose_float(vn_d - lzero_d);
        digit = xp + new_parts.EXPONENT;
        return
        %%NEW: COUNT number of leading 0s after xor
        p_l = typecast(p, l_type); 
        q_l = typecast(q, l_type);
        mn_l = bitxor(p_l, q_l);
        %mn_l = bitxor(mp_l, mq_l);
        digit = clz(mn_l);
    end
end
end


function [xval] = xor_strings(str1, str2) 

xval = xor(str2num(str1(3:54)'), str2num(str2(3:54)'))';

end

function [xval exval] = xor_dvals(val1, val2)
str1 = num2bin(val1)
str2 = num2bin(val2)
lzero = num2bin(0.5)
%str1 = dec2bin(typecast(val1, 'uint64'),64); 
%str2 = dec2bin(typecast(val2, 'uint64'),64); 
xval = xor(str2num(str1(3:55)'), str2num(str2(3:55)'));
xval = or(xval, str2num(lzero(3:55)'))'
exval = str2num(str1(59:end)) - str2num(str2(59:end))
end

% Test this pattern: 
%nodes = [ 0 0; 0 1; 0 2; 0 3; 0 4; 1 0; 1 1; 1 2; 1 3; 1 4; 2 0; 2 1; 2 2; 2 3; 2 4; 3 0; 3 1; 3 2; 3 3; 3 4; 4 0; 4 1; 4 2; 4 3; 4 4; 5 0; 5 1; 5 2; 5 3; 5 4; 5 5; 0 5; 1 5; 2 5; 3 5; 4 5]