DIM = 3;
n=2;
NX = 2^n; 
if DIM == 1
    [nodeX, nodeY, nodeZ] = meshgrid(linspace(0,1,NX),0,0);
    [ijkX, ijkY, ijkZ] = meshgrid(1:NX,0,0); 
elseif DIM == 2
    [nodeX, nodeY, nodeZ] = meshgrid(linspace(0,1,NX),linspace(0,1,NX),0);
    [ijkX, ijkY, ijkZ] = meshgrid(1:NX,1:NX,0); 
elseif DIM==3
    [nodeX, nodeY, nodeZ] = meshgrid(linspace(0,1,NX),linspace(0,1,NX),linspace(0,1,NX));
    [ijkX, ijkY, ijkZ] = meshgrid(1:NX,1:NX,0);
else
    fprintf('Error, No support for dimensions greater than 3\n');
    return;
end

nodes = [nodeX(:), nodeY(:), nodeZ(:)];
ijk_ind = [ijkX(:), ijkY(:), ijkZ(:)];

plot3(nodes(:,1), nodes(:,2), nodes(:,3),'o-');

morton_ind = ijk_to_morton(ijk_ind, DIM, [0,1]);

s_nodes = nodes(morton_ind+1,:); 
plot3(s_nodes(:,1), s_nodes(:,2), s_nodes(:,3),'o-');

%plot(nodes(morton_ind,1), nodes(morton_ind,2),'o-');