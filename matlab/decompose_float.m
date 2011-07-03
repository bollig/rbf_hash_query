function [parts] = decompose_float(v)
%% Auto decompose float into sign exponent and mantissa parts:
%
%   NOTE: Connor uses [ma] = frexp(v, &ex) in C++. Matlab's 
%         [ma ex] = log2(v) is equivalent
[ma ex] = log2(v);
parts = struct('SIGN', sign(v), 'EXPONENT', ex, 'MANTISSA', ma);
end