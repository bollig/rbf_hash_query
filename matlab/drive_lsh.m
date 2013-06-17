%clear all;

DIM = 2;
% Number of nodes in one dimension (ie., [N]^dim)
N = 10;
CELL_OVERLAY_NX = N;
plotCurves = 1;

%% 0: Regular Distribution; 1: Random Distribution; 2: Load Grid.
testNodeType=0


global debug;
debug =1; 


if testNodeType==0
    NX = CELL_OVERLAY_NX*2;
    %NX = N;
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
    nodes = [10 .* rand(N,DIM) zeros(N,1)];
elseif testNodeType==2
    nodes = load('loadedgrid_1024nodes_final.ascii');
end


addpath('int_morton')



%% OLD:
%[sten snodes] = knn_lsh_with_ijk_hash(nodes, 5, 10);

%% NEW:
if debug
    figure
end
[sten snodes ch cp] = knn_lsh(nodes, 10, CELL_OVERLAY_NX, 3, @ijk_to_x );

spy_stencils(sten);