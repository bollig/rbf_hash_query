
n=3; 
NX = 2^n;

[nodeX, nodeY] = meshgrid(linspace(0,1,NX),linspace(0,1,NX));
nodes = [nodeX(:), nodeY(:)];

plot(nodes(:,1), nodes(:,2),'o-');

morton_ind = morton(n); 

plot(nodes(morton_ind,1), nodes(morton_ind,2),'o-');