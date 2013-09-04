function [dilated] = dilate(X_dec, DIM, M)
%% Usage: dialate(X, 3, 2) would be the same as DIL_32(X)
%% Following the algorithm in paper by L. Stocco ("On Spatial Orders and Location
%% Codes", IEEE Transactions on Computers, Vol. 58, No. 3, March 2009)
% WARNING! ONLY OUTPUTS A uint32

global debug 

%% Assume we have 32-bit integers
steps = log2(32);

%% MAX uint16:
%X = hex2dec('FFFF');
%dec2bin(X);

X = X_dec; %bin2dec(X_bin)
X_pp = X;
for i = steps:-1:1
    X_p = X_pp;
    N = M*2^(i-1);
    P = DIM*2^(i-1);
    mask = genmask(P,N);
    if debug
       fprintf('((X_p << %d) | X_p) & %x\n', P, mask)
    end
    %dec2hex(mask);
    %X_pp = dilate_n_m(X_pp,N,i);
    X_pp = bitand(bitor(X_p, bitshift(X_p,P)), mask);
    %dec2bin(X_pp);
    if (N == M)
        break;
    end
end

dilated = X_pp; %dec2bin(X_pp);

end


function [mask] = genmask(N,M,intLength)
%% genmask - Generate a mask with repeating patterns of 0's and 1's
%%%%%%%%%%%%%%
% Parameters:
% N : Number of Zeros (typically your dimension if youre dialating integers
%       for node ordering).
% M : Number of Ones
% intLength : Number of BITS for the mask length
%%%%%%%%%%%%%%

if nargin < 3
    intLength = 32;
end

mask = '';
isZeros = false;

atom = strcat(repmat('0',1,N),repmat('1',1,M));

for i = 1:N+M:intLength
    mask = strcat(mask,atom);
end

%mask = bin2dec(mask(1+(end-min(48,end)):end));
% Trim to requested size.
mask = bin2dec(mask((1+(end-intLength)):end));

end