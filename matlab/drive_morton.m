DIM = 2;
n=2;
NX = 2^n;

if DIM == 1
    [nodeX, nodeY, nodeZ] = meshgrid(linspace(0,1,NX),0,0);
elseif DIM == 2
    [nodeX, nodeY, nodeZ] = meshgrid(linspace(0,1,NX),linspace(0,1,NX),0);
elseif DIM==3
    [nodeX, nodeY, nodeZ] = meshgrid(linspace(0,1,NX),linspace(0,1,NX),linspace(0,1,NX));
else
    fprintf('Error, No support for dimensions greater than 3\n');
    return;
end

nodes = [nodeX(:), nodeY(:), nodeZ(:)];

plot3(nodes(:,1), nodes(:,2), nodes(:,3),'o-');

ijk_ind = (1:NX^DIM) - 1;

morton_ind = ijk_to_morton(ijk_ind, DIM, [0,1]);

%plot(nodes(morton_ind,1), nodes(morton_ind,2),'o-');