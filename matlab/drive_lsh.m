%clear all;

DIM = 2;
% Number of nodes in one dimension (ie., [N]^dim)
N = 3;
CELL_OVERLAY_NX = 6;
NX = N*CELL_OVERLAY_NX;

n = 31;
plotCurves = 1;

%% 0: Regular Distribution; 1: Random Distribution; 2: Halton Seq; 3: Load Grid.
testNodeType=0


global debug;
debug = 0; 


if testNodeType==0
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
    NX = NX^DIM;
    % Random between [0,10]^2
    nodes = [10 .* rand(NX,DIM) zeros(NX,2)];
    nodes = nodes(:,1:3);    
elseif testNodeType==2
    NX = NX^DIM;
    % Generate the halton sequence
    p = haltonset(DIM,'Skip',1e3,'Leap',1e2);
    % NOTE: scale and offset by 1 to ensure we're in [-1,1]
    nodes = [2 * net(p, NX) - 1 zeros(NX,2)];
    nodes = nodes(:,1:3);
    
elseif testNodeType==3
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

figure
hold on
subplot(2,3,2);
spy_stencils(node4_z_order.sten);
title('4-nodes per Edge (Z) Order');

subplot(2,3,3);
spy_stencils(ijk_order.sten);
title('Raster (IJK) Order');

subplot(2,3,4);
spy_stencils(x_order.sten);
title('Cross (X) Order');

subplot(2,3,5);
spy_stencils(z_order.sten);
title('Morton (Z) Order');

subplot(2,3,6);
spy_stencils(u_order.sten);
title('Gray-Code (U) Order');

hold off