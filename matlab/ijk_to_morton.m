function [morton_ind] = ijk_to_morton

linind=(1:4^n)-1; %start index count for array at zero
ind2str=dec2bin(linind); %convert indices to base-2
rb=ind2str(:,1:2:end); %take alternating bits for row and column
cb=ind2str(:,2:2:end);
r=bin2dec(rb)+1; %convert the row from bit to decimal
c=bin2dec(cb)+1; %convert column
ind=[2^n*(c-1)+r]'; %make a linear index into array for easy addressing

end