%clear all;

DIM = 3;
% Number of nodes in one dimension (ie., [N]^dim)
N = 1;
CELL_OVERLAY_NX = 10;
n = 31;
plotCurves = 1;

%% 0: Regular Distribution; 1: Random Distribution; 2: Load Grid.
testNodeType=2


global debug;
debug = 0; 


if testNodeType==0
    NX = N*CELL_OVERLAY_NX;
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
    nodes = load('/Users/evan/sphere_grids/md063.04096');
    nodes = nodes(:,1:3); 
end


addpath('int_morton')

fprintf('Z-ordering\n');
[sten snodes ch cp] = knn_lsh(nodes, n, CELL_OVERLAY_NX, 3, @ijk_to_z);
figure(2)
z_order.bandwidth = spy_stencils(sten);
z_order.rcm_bandwidth = symrcm_stencils(sten);
z_order.sten = sten;
z_order.snodes = snodes; 
z_order.ch = ch; 
z_order.cp = cp; 

fprintf('U-ordering\n');
[sten snodes ch cp] = knn_lsh(nodes, n, CELL_OVERLAY_NX, 3, @ijk_to_u);
figure(3)
u_order.bandwidth = spy_stencils(sten);
u_order.rcm_bandwidth = symrcm_stencils(sten);
u_order.sten = sten;
u_order.snodes = snodes; 
u_order.ch = ch; 
u_order.cp = cp; 

fprintf('X-ordering\n');
[sten snodes ch cp] = knn_lsh(nodes, n, CELL_OVERLAY_NX, 3, @ijk_to_x);
figure(4)
x_order.bandwidth = spy_stencils(sten);
x_order.rcm_bandwidth = symrcm_stencils(sten);
x_order.sten = sten;
x_order.snodes = snodes; 
x_order.ch = ch; 
x_order.cp = cp; 

fprintf('4 node Z-ordering\n');
[sten snodes ch cp] = knn_lsh(nodes, n, CELL_OVERLAY_NX, 3, @ijk_to_4node_z);
figure(5)
node4_z_order.bandwidth = spy_stencils(sten);
node4_z_order.rcm_bandwidth = symrcm_stencils(sten);
node4_z_order.sten = sten;
node4_z_order.snodes = snodes; 
node4_z_order.ch = ch; 
node4_z_order.cp = cp; 


fprintf('IJK-ordering\n');
[sten snodes ch cp] = knn_lsh(nodes, n, CELL_OVERLAY_NX, 3, @ijk_to_ijk);
figure(6)
ijk_order.bandwidth = spy_stencils(sten);
ijk_order.rcm_bandwidth = symrcm_stencils(sten);
ijk_order.sten = sten;
ijk_order.snodes = snodes; 
ijk_order.ch = ch; 
ijk_order.cp = cp; 