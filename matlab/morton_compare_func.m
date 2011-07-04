function [direction] = morton_compare_func(input, indx_p, indx_q)
%% Floating Point Implicit Morton Order Sort Algorithm
% Requires: d-dimensional points p and q
% Returns: 
%       -1 if p < q in Morton order
%        1 if p > q in Morton order
%        0 if p == q in Morton order
%
% The details of this come from Connor's Thesis:
%       http://www.cs.fsu.edu/research/theses/Thesis-MichaelConnor.pdf
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
if iscell(input)
p = input{indx_p,:};
q = input{indx_q,:};
else 
p = input(indx_p,:);
q = input(indx_q,:);
end

% The number of leading zeros on most differing dimension
x = 0;
j = 1;
% Node dimensions
d = size(p, 2);

for k = 1:d
    if (p(k) < 0) ~= (q(k) < 0)
        j = k; 
        x = 0; 
        break; 
    end
    
    %% THIS IS THE BITWISE OPERATION. CURRENTLY ONLY WORKS FOR INTEGER
    %% NODES... not sure why. 
    % Using vector notation just in case. It really should only compare one
    % node to one other, but you never know in matlab.
    y = xor_msb(p(k), q(k))
    if x < y
        % Update the DIMENSION in which we compare
        j = k;
        % Update the EXPONENT (magnitude) of difference
        x = y;
    end
    %display([dec2bin(typecast(p(k), 'uint64'),64); dec2bin(typecast(q(k), 'uint64'),64)])
end
points = [p; q]

results = [j, x]

if p(j) < q(j) 
    direction = -1; 
elseif p(j) > q(j) 
    direction = 1; 
else 
    direction = 0; 
end
end
