DIM = 2;
NX = 8; 
if DIM == 1
    %[nodeX, nodeY, nodeZ] = meshgrid(linspace(0,1,NX),0,0);
    [nodeX, nodeY, nodeZ] = meshgrid(1:NX,0,0);
    [ijkX, ijkY, ijkZ] = meshgrid(1:NX,0,0); 
elseif DIM == 2
    %[nodeX, nodeY, nodeZ] = meshgrid(linspace(0,1,NX),linspace(0,1,NX),0);
    [nodeX, nodeY, nodeZ] = meshgrid(1:NX,1:NX,0);
    [ijkX, ijkY, ijkZ] = meshgrid(1:NX,1:NX,0); 
elseif DIM==3
    [nodeX, nodeY, nodeZ] = meshgrid(1:NX,1:NX,1:NX);
   % [nodeX, nodeY, nodeZ] = meshgrid(linspace(0,1,NX),linspace(0,1,NX),linspace(0,1,NX));
    [ijkX, ijkY, ijkZ] = meshgrid(1:NX,1:NX,1:NX);
else
    fprintf('Error, No support for dimensions greater than 3\n');
    return;
end

nodes = [nodeX(:), nodeY(:), nodeZ(:)];
ijk_ind = [ijkX(:), ijkY(:), ijkZ(:)];

%subplot(2,1,1)
plot3(nodes(:,1), nodes(:,2), nodes(:,3),'o-');

morton_ind = ijk_to_x(ijk_ind, DIM, [0,1]);

[temp morton_compressed_ind] = sort(morton_ind); 
s_nodes = nodes(morton_compressed_ind,:); 
%subplot(2,1,2)
plot3(s_nodes(:,1), s_nodes(:,2), s_nodes(:,3),'o-');
xlabel('k');
ylabel('i');
zlabel('j');


subplot(2,2,1); 
plot(nodes(:,1), nodes(:,2), 'o-');
title('Original (Raster) Order');


subplot(2,2,2); 
morton_ind = ijk_to_zz(ijk_ind, DIM, [0,1]);
[temp morton_compressed_ind] = sort(morton_ind); 
s_nodes = nodes(morton_compressed_ind,:); 
plot(s_nodes(:,1), s_nodes(:,2), 'o-');
title('Morton (Z) Order');

subplot(2,2,3); 
morton_ind = ijk_to_u(ijk_ind, DIM, [0,1]);
[temp morton_compressed_ind] = sort(morton_ind); 
s_nodes = nodes(morton_compressed_ind,:); 
plot(s_nodes(:,1), s_nodes(:,2), 'o-');
title('Gray-Code (U) Order');

subplot(2,2,4); 
morton_ind = ijk_to_x(ijk_ind, DIM, [0,1]);
[temp morton_compressed_ind] = sort(morton_ind); 
s_nodes = nodes(morton_compressed_ind,:); 
plot(s_nodes(:,1), s_nodes(:,2), 'o-');
title('Cross (X) Order');
