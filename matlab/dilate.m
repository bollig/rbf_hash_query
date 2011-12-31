function [dilated] = dilate(X_dec, DIM, M)
%% Usage: dialate(X, 3, 2) would be the same as DIL_32(X)
%% Following the algorithm in paper by L. Stocco ("On Spatial Orders and Location
%% Codes", IEEE Transactions on Computers, Vol. 58, No. 3, March 2009)
% WARNING! ONLY OUTPUTS A uint32

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