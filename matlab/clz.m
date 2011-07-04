function [nzers] = clz(uint64_val)
%bits = bitget(uint64_val,52:1); 
bits = bitget(uint64_val,52:-1:1); 
bstr = mat2str(bits)
% Find the first occurrence of 1.
nzers = find(bits,1); 
end
