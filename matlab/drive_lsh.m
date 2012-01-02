%clear all;

DIM = 2;
NX = 10;
plotCurves = 1;
testAll = 1;
if DIM == 1
    %[nodeX, nodeY, nodeZ] = meshgrid(linspace(0,1,NX),0,0);
    [nodeX, nodeY, nodeZ] = meshgrid(0:NX-1,0,0);
    [ijkX, ijkY, ijkZ] = meshgrid(0:NX-1,0,0);
elseif DIM == 2
    %[nodeX, nodeY, nodeZ] = meshgrid(linspace(0,1,NX),linspace(0,1,NX),0);
    [nodeX, nodeY, nodeZ] = meshgrid(0:NX-1,0:NX-1,0);
    [ijkX, ijkY, ijkZ] = meshgrid(0:NX-1,0:NX-1,0);
elseif DIM==3
    [nodeX, nodeY, nodeZ] = meshgrid(0:NX-1,0:NX-1,0:NX-1);
    % [nodeX, nodeY, nodeZ] = meshgrid(linspace(0,1,NX),linspace(0,1,NX),linspace(0,1,NX));
    [ijkX, ijkY, ijkZ] = meshgrid(0:NX-1,0:NX-1,0:NX-1);
else
    fprintf('Error, No support for dimensions greater than 3\n');
    return;
end

nodes = [nodeX(:), nodeY(:), nodeZ(:)];
clear nodeX nodeY nodeZ;

ijk_ind = [ijkX(:), ijkY(:), ijkZ(:)];
clear ijkX ijkY ijkZ;



addpath('int_morton')





%% OLD: 
%[sten snodes] = knn_lsh_with_ijk_hash(nodes, 5, 10);

%% NEW: 
[sten snodes ch cp] = knn_lsh(nodes, 5, 10, @ijk_to_z );

%spy_stencils(sten);