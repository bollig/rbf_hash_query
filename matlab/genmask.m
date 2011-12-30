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