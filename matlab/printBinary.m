function [] = printBinary(fval)

lval = typecast(fval, 'uint64');

NumAsString = dec2bin(lval, 32); 
display(NumAsString);
NumAsFloat32 = typecast( uint32( bin2dec( NumAsString ) ), 'single');
display(NumAsFloat32);
end