function [INT] = interleave_bits(bit_len, arg1, arg2, arg3)

if nargin < 3
    INT = arg1;     
elseif nargin < 4
    INT=arg1 + dec2bin(bitshift(bin2dec(arg1), 4))
else
    
end


