function [direction] = morton_compare_func2(input, indx_p, indx_q)
%% Floating Point Implicit Morton Order Sort Algorithm
% Requires: d-dimensional points p and q
% Returns: 
%       -1 if p < q in Morton order
%        1 if p > q in Morton order
%        0 if p == q in Morton order
%
% The details of this come from Connor's Thesis:
%       http://www.cs.fsu.edu/research/theses/Thesis-MichaelConnor.pdf
% and from wikipedia: 
%       http://en.wikipedia.org/wiki/Z-order_curve
%
% Compare nodes p and q and determine if p < q according to the Morton
% ordering (space filling Z-curve)
%
% There are limits to this function given truncation. For example: 
%   morton_lt_func(1e10, 1e10+1e-6) returns TRUE
%   morton_lt_func(1e10, 1e10+1e-7) returns FALSE
% This should not cause too much trouble though, since MOST of our neighbor
% queries depend on APPROXIMATE nearest neighbors and the sorting will only
% effect caching (and only minimally at that). 

p = input(indx_p,:) ;
q = input(indx_q,:) ;


j = 1; 
k = 0; 
x = uint64(0); 

dim = size(p,2); 

for k = dim:-1:1
    % Connors approach in his thesis worked for integers, but I couldnt get
    % it to work for doubles. I am trying again. 
    y = xor_imsb(p(k), q(k));
    if x < y
        j = k; 
        x = y; 
        %[j x]
    end
end

direction = p(j) - q(j); 
if direction < 0
    direction = -1; 
elseif direction > 0
    direction = 1; 
else 
    direction = 0; 
end
end

function [l] = less_msb(a, b)
    x = typecast(a, 'uint64');
    y = typecast(b, 'uint64');
    l = (a < b);
    m = x < bitxor(x,y);
    l = xor(l,m);
end


function [xval] = xor_dmsb(val1, val2)

[mp_d xp] = log2(val1) ;
[mq_d xq] = log2(val2);

mp_l = typecast(mp_d, 'uint64');
mq_l = typecast(mq_d, 'uint64');

lzero_d = 0.5;
lzero_l = typecast(lzero_d, 'uint64');

if (xp < xq)
   xval = xq;  
elseif (xp == xq) 
    if mp_l == mq_l
        xval = 0; 
    else
       % mx_l = bitor(bitxor(bitor(mp_l, lzero_l), bitor(mq_l, lzero_l)), lzero_l);
        mx_l = bitxor(mp_l, mq_l);
        nx_l = bitor(mx_l, lzero_l);
        mx_d = typecast(mx_l, 'double');  
        nx_d = typecast(nx_l, 'double');
        ox_d = nx_d - lzero_d; 
              
        display(num2bin(mp_d));
        display(num2bin(mq_d));
        display(num2bin(mx_d));
        display(num2bin(nx_d));
        display(num2bin(ox_d));
        vx = num2bin(nx_d); 
        wx = num2bin(mx_d); 
        vy = num2bin(ox_d);
        
        % exponent
        xx = str2num(vy(59:end));
        found = [0, find(wx == '1',2) - 3];
        [mx_d xx2] = log2(ox_d)
        xp
        xval = uint64(xp + xx2);
    end
else
    xval = xp; 
end

end

function [xval] = xor_imsb(val1, val2)

[mp_d xp] = log2(val1) ;
[mq_d xq] = log2(val2);

mp_l = typecast(mp_d, 'uint64');
mq_l = typecast(mq_d, 'uint64');

lzero_d = 0.5;
lzero_l = typecast(lzero_d, 'uint64');

if (xp < xq)
   xval = xq;  
elseif (xp == xq) 
    if mp_l == mq_l
        xval = 0; 
    else
       % mx_l = bitor(bitxor(bitor(mp_l, lzero_l), bitor(mq_l, lzero_l)), lzero_l);
        mx_l = bitxor(mp_l, mq_l);
        nx_l = bitor(mx_l, lzero_l);
        mx_d = typecast(mx_l, 'double');  
        nx_d = typecast(nx_l, 'double');
        ox_d = nx_d - lzero_d; 
              
        %display(num2bin(mp_d));
        %display(num2bin(mq_d));
        %display(num2bin(mx_d));
        %display(num2bin(nx_d));
        %display(num2bin(ox_d));
        vx = num2bin(nx_d); 
        wx = num2bin(mx_d); 
        vy = num2bin(ox_d);
        
        % exponent
        xx = str2num(wx(59:end));
        found = [0, find(wx == '1',2) - 3];
        [mx_d xx2] = log2(ox_d);
        %xp
        xval = uint64(xp + xx2);
    end
else
    xval = xp; 
end

end

function [xval] = xor_dvals(val1, val2)

uval1 = typecast(val1, 'uint64');
uval2 = typecast(val2, 'uint64');

xval = bitxor(uval1, uval2);

end