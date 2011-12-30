function [dilated] = dilate(X, DIM, M)
%% Usage: dialate(X, 3, 2) would be the same as DIL_32(X)
%% Following the algorithm in paper by L. Stocco ("On Spatial Orders and Location
%% Codes", IEEE Transactions on Computers, Vol. 58, No. 3, March 2009)
 
global masks;

%% 64bit masks:
masks_64 = [ 
 '5555555555555555',
 '3333333333333333',
 '0F0F0F0F0F0F0F0F',
 '00FF00FF00FF00FF',
 '0000FFFF0000FFFF'
];

masks_32 = [
 '55555555',
 '33333333',
 '0F0F0F0F',
 '00FF00FF',
 '0000FFFF'
];


%% We can only accept uint16 since we only have masks up to 32bits
masks = hex2dec(masks_32); 


%% Assume we have 32-bit integers
steps = log2(32); 

%% MAX uint16: 
X = hex2dec('F');
dec2bin(X);

%% This is dialate(1,1)
%X_1 = dilate_16_16(X);
%X_2 = dilate_8_8(X_1);
%X_3 = dilate_4_4(X_2);
%X_4 = dilate_2_2(X_3);
%X_5 = dilate_1_1(X_4);

X_pp = X; 
for i = steps:-1:1
   X_p = X_pp; 
   N = M*2^(i-1)
   P = DIM*2^(i-1)
   mask = genmask(P,N);
   dec2hex(mask)
   %X_pp = dilate_n_m(X_pp,N,i);
   X_pp = bitand(bitor(X_p, bitshift(X_p,P)), mask);
   dec2bin(X_pp)
   if (N == M)
       %% DIL_22 should stop before evaluating dilate(X_pp, 1, 1)
       %break; 
   end
end

dilated = dec2bin(X_pp);

end

function [res] = dilate_16_16(X)
global masks;
dec2bin(masks)
X_shifted = bitshift(X,16); 
dec2bin(bitor(X, X_shifted))
res = bitand(bitor(X, X_shifted), masks(5)); 
end


function [res] = dilate_8_8(X)
global masks;
X_shifted = bitshift(X,8); 
res = bitand(bitor(X, X_shifted), masks(4)); 
end


function [res] = dilate_4_4(X)
global masks;
X_shifted = bitshift(X,4); 
res = bitand(bitor(X, X_shifted), masks(3)); 
end

function [res] = dilate_2_2(X)
global masks;
X_shifted = bitshift(X,2); 
res = bitand(bitor(X, X_shifted), masks(2)); 
end

function [res] = dilate_1_1(X)
global masks;
X_shifted = bitshift(X,1); 
res = bitand(bitor(X, X_shifted), masks(1)); 
end


function [res] = dilate_n_m(X, n, m)
%% Parameters: 
%% n ->  Number of Zeros
%% m ->  Number of NonZeros
global masks;
X_shifted = bitshift(X,n); 
res = bitand(bitor(X, X_shifted), masks(m)); 
end