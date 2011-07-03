function [cvec1] = msdb(val1, val2)

[mant1 ex1] = log2(val1) 
[mant2 ex2] = log2(val2) 

mbin1 = typecast(mant1, 'uint64'); 
mbin2 = typecast(mant2, 'uint64'); 

cvec1 = ((bitget(mbin1, 64:-1:12)))
%str1 = dec2hex(cvec1)
%cvec2 = mat2str(bitget(mbin2, 1:32)) 
%str2 = dec2hex(cvec2)'
%cvec3 = mat2str(bitget(bitxor(mbin1, mbin2), 1:64)); 
%str3 = dec2hex(cvec3)'
mat2str(dec2bin(mbin1,64))


%xord = [dec2bin(mbin1, 64); dec2bin(mbin2, 64); dec2bin(bitxor(mbin1, mbin2),64)]
xord = [str1; str2; str3]

dec2bin(typecast(0.5, 'uint64'),64)

xrd = xord(3,1:52)
xrd = xord(3,13:64)
bin2dec(xrd)
bin2dec('111100011011')
%frexp(x.sig.d-0.5, &y.exp);
[man3 ex3] = log2(bin2dec(xrd))
dec2bin(typecast(ex3, 'uint64'))
end