function [TF] = morton_lt_func(input, indx_p, indx_q)
%% Floating Point Implicit Morton Order Sort Algorithm
% Requires: d-dimensional points p and q
% Returns: 
%       true  if p <= q in Morton order
%       false if p > q in Morton order
% If using a generalized sort algorithm that depends on a COMPARISON
% operator (i.e., return values -1, 0 and 1 for < than, equal to and >
% than, use the MORTON_COMPARE_FUNCTION.m 
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

p = input(indx_p,:);
q = input(indx_q,:);

% The negative here swaps flips the bits to give us the min value
x = 0;
j = 1;
dim = 0;
% Node dimensions
d = size(p, 2);
for k = 1:d
    % Using vector notation just in case. It really should only compare one
    % node to one other, but you never know in matlab.
    y = xor_msb(p(k), q(k));
    if x < y
        j = k
        x = y;
    end
end
TF = p(j) < q(j);
end