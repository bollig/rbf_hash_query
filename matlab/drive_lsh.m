%clear all;

DIM = 2;
NX = 8;
CELL_OVERLAY_NX = 4;
plotCurves = 1;

%% 0: Regular Distribution; 1: Random Distribution; 2: Load Grid.
testNodeType=1


if testNodeType==0
    
    if DIM == 1
        [nodeX, nodeY, nodeZ] = meshgrid(0:NX-1,0,0);
        [ijkX, ijkY, ijkZ] = meshgrid(0:NX-1,0,0);
    elseif DIM == 2
        [nodeX, nodeY, nodeZ] = meshgrid(0:NX-1,0:NX-1,0);
        [ijkX, ijkY, ijkZ] = meshgrid(0:NX-1,0:NX-1,0);
    elseif DIM==3
        [nodeX, nodeY, nodeZ] = meshgrid(0:NX-1,0:NX-1,0:NX-1);
        [ijkX, ijkY, ijkZ] = meshgrid(0:NX-1,0:NX-1,0:NX-1);
    else
        fprintf('Error, No support for dimensions greater than 3\n');
        return;
    end
    
    nodes = [nodeX(:), nodeY(:), nodeZ(:)];
    clear nodeX nodeY nodeZ;
    
    ijk_ind = [ijkX(:), ijkY(:), ijkZ(:)];
    clear ijkX ijkY ijkZ;
    
elseif testNodeType==1
    % Random between [0,10]^2
    nodes = 10 .* rand(NX^DIM,DIM);
elseif testNodeType==2
    nodes = load('loadedgrid_1024nodes_final.ascii');
end


addpath('int_morton')





%% OLD:
%[sten snodes] = knn_lsh_with_ijk_hash(nodes, 5, 10);

%% NEW:
[sten snodes ch cp] = knn_lsh(nodes, 5, CELL_OVERLAY_NX, @ijk_to_z );

%spy_stencils(sten);