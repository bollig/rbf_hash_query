%clear all;
close all;
addpath('./int_morton');

DIM = 3;
% Number of nodes in one dimension (ie., [N]^dim)
N = 3;
n = 31;

CELL_OVERLAY_NX = 10; %floor(n/2);
NX = CELL_OVERLAY_NX * N;

plotCurves = 1;

%% 0: Regular Distribution; 1: Random Distribution; 2: Halton Seq; 3: Load Grid.
testNodeType=3;


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
    testcase = 'Regular Grid'; 
    
elseif testNodeType==1
    NX = NX^DIM;
    % Random between [0,10]^2
    nodes = [10 .* rand(NX,DIM) zeros(NX,2)];
    nodes = nodes(:,1:3); 
    
    testcase = 'Random Grid'; 
elseif testNodeType==2
    NX = NX^DIM;
    % Generate the halton sequence
    p = haltonset(DIM,'Skip',1e3,'Leap',1e2);
    % NOTE: scale and offset by 1 to ensure we're in [-1,1]
    nodes = [2 * net(p, NX) - 1 zeros(NX,2)];
    nodes = nodes(:,1:3);
    
    testcase = 'Halton Grid'; 
elseif testNodeType==3
    nodes = load('/Users/evan/sphere_grids/md063.04096');
    nodes = nodes(:,1:3); 
    DIM=3;
    testcase = 'MD Sphere Grid'; 
end


addpath('int_morton')

fprintf('KDTree-ordering\n');
USE_KDTREE = 1;
figure
[sten snodes ch cp] = knn_lsh(nodes, n, CELL_OVERLAY_NX, 3, @ijk_to_z, USE_KDTREE);
kdtree_order.bandwidth = spy_stencils(sten);
kdtree_order.rcm = symrcm_stencils(sten);
kdtree_order.sten = sten;
kdtree_order.snodes = snodes; 
kdtree_order.ch = ch; 
kdtree_order.cp = cp; 

fprintf('KDTree-ordering\n');
USE_KDTREE = 1;
figure
[sten snodes ch cp] = knn_lsh(nodes, n, CELL_OVERLAY_NX, 3, @ijk_to_z, USE_KDTREE);
kdtree_unsorted_order.bandwidth = spy_stencils(sten);
kdtree_unsorted_order.rcm = symrcm_stencils(sten);
kdtree_unsorted_order.sten = sten;
kdtree_unsorted_order.snodes = snodes; 
kdtree_unsorted_order.ch = ch; 
kdtree_unsorted_order.cp = cp; 


USE_KDRTREE=0;

% Gordon: set to 0 if you dont want to see what the orderings do
debug=0

fprintf('Z-ordering\n');
figure
[sten snodes ch cp] = knn_lsh(nodes, n, CELL_OVERLAY_NX, 3, @ijk_to_z);
z_order.bandwidth = spy_stencils(sten);
z_order.rcm = symrcm_stencils(sten);
z_order.sten = sten;
z_order.snodes = snodes; 
z_order.ch = ch; 
z_order.cp = cp; 
dlmwrite('z_stencils', sten);

fprintf('U-ordering\n');
figure
[sten snodes ch cp] = knn_lsh(nodes, n, CELL_OVERLAY_NX, 3, @ijk_to_u);
u_order.bandwidth = spy_stencils(sten);
u_order.rcm = symrcm_stencils(sten);
u_order.sten = sten;
u_order.snodes = snodes; 
u_order.ch = ch; 
u_order.cp = cp; 
dlmwrite('u_stencils', sten);

fprintf('X-ordering\n');
figure
[sten snodes ch cp] = knn_lsh(nodes, n, CELL_OVERLAY_NX, 3, @ijk_to_x);
x_order.bandwidth = spy_stencils(sten);
x_order.rcm = symrcm_stencils(sten);
x_order.sten = sten;
x_order.snodes = snodes; 
x_order.ch = ch; 
x_order.cp = cp; 
dlmwrite('x_stencils', sten);

fprintf('4 node Z-ordering\n');
figure
[sten snodes ch cp] = knn_lsh(nodes, n, CELL_OVERLAY_NX, 3, @ijk_to_4node_z);
node4_z_order.bandwidth = spy_stencils(sten);
node4_z_order.rcm = symrcm_stencils(sten);
node4_z_order.sten = sten;
node4_z_order.snodes = snodes; 
node4_z_order.ch = ch; 
node4_z_order.cp = cp; 
dlmwrite('node4_z_stencils', sten);


fprintf('IJK-ordering\n');
figure
[sten snodes ch cp] = knn_lsh(nodes, n, CELL_OVERLAY_NX, 3, @ijk_to_ijk);
ijk_order.bandwidth = spy_stencils(sten);
ijk_order.rcm = symrcm_stencils(sten);
ijk_order.sten = sten;
ijk_order.snodes = snodes; 
ijk_order.ch = ch; 
ijk_order.cp = cp; 

dlmwrite('ijk_stencils', sten);
dlmwrite('ijk_nodes', snodes);

figure
hold on

subplot(2,3,1);
spy_stencils(ijk_order.sten);
title('Raster (IJK) Order');
xlabel(sprintf('%s; bw=%d', get(get(gca,'XLabel'), 'String'), ijk_order.bandwidth));


subplot(2,3,3);
spy_stencils(node4_z_order.sten);
title('4-nodes per Edge (Z) Order');
xlabel(sprintf('%s; bw=%d', get(get(gca,'XLabel'), 'String'), node4_z_order.bandwidth));

subplot(2,3,2);
spy_stencils(ijk_order.sten, ijk_order.rcm.r);
title('Reverse Cuthill McKee (IJK)');
xlabel(sprintf('%s; bw=%d', get(get(gca,'XLabel'), 'String'), ijk_order.rcm.bandwidth));

subplot(2,3,4);
spy_stencils(x_order.sten);
title('Cross (X) Order');
xlabel(sprintf('%s; bw=%d', get(get(gca,'XLabel'), 'String'), x_order.bandwidth));

subplot(2,3,5);
spy_stencils(z_order.sten);
title('Morton (Z) Order');
xlabel(sprintf('%s; bw=%d', get(get(gca,'XLabel'), 'String'), z_order.bandwidth));

subplot(2,3,6);
spy_stencils(u_order.sten);
title('Gray-Code (U) Order');
xlabel(sprintf('%s; bw=%d', get(get(gca,'XLabel'), 'String'), u_order.bandwidth));

hold off

suptitle(sprintf('N=%d %s (%d-D); n=%d, h_n=%d', size(nodes,1), testcase, DIM, n, CELL_OVERLAY_NX));

