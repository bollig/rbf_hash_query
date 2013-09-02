clear all;

DIM = 2;
NX = 8;

cell_props.dim = DIM; 
cell_props.hnx = NX

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

%subplot(2,1,2)
% plot3(s_nodes(:,1), s_nodes(:,2), s_nodes(:,3),'o-');
% xlabel('k');
% ylabel('i');
% zlabel('j');

if plotCurves
    subplot(2,3,1);
    plot3(nodes(:,1), nodes(:,2), nodes(:,3),'o-');
    title('Original (Raster) Order');
    axis([-1 NX -1 NX -1 NX]);
    view(max(2,DIM))
end

if plotCurves
    kdtree = KDTreeSearcher(nodes,'distance','euclidean');
    sten = knnsearch(kdtree, nodes, 'k',5);
    kdtree_order.rcm = symrcm_stencils(sten, 0);
    
    subplot(2,3,2);
    s_nodes = nodes(kdtree_order.rcm.r,:);
    plot3(s_nodes(:,1), s_nodes(:,2), s_nodes(:,3),'o-');
    title('Reverse Cuthill-McKee (n=3; *)');
    axis([-1 NX -1 NX -1 NX]);
    view(max(2,DIM))
end

%% Z-order
morton_ind = ijk_to_z(ijk_ind, cell_props);
%% Alternative: (Each Z is 4 nodes per edge)
% morton_ind = ijk_to_4node_z(ijk_ind, DIM);
[temp morton_compressed_ind] = sort(morton_ind);
s_nodes = nodes(morton_compressed_ind,:);

if plotCurves
    subplot(2,3,5);
    plot3(s_nodes(:,1), s_nodes(:,2), s_nodes(:,3),'o-');
    title('Morton (Z) Order');
    axis([-1 NX -1 NX -1 NX]);
    view(max(2,DIM))
end

if testAll
    
    %% U-order
    morton_ind = ijk_to_u(ijk_ind, cell_props);
    [temp morton_compressed_ind] = sort(morton_ind);
    s_nodes = nodes(morton_compressed_ind,:);
    
    if plotCurves
        subplot(2,3,6);
        plot3(s_nodes(:,1), s_nodes(:,2), s_nodes(:,3),'o-');
        title('Gray-Code (U) Order');
        axis([-1 NX -1 NX -1 NX]);
        view(max(2,DIM))
    end
    
    %% X-order
    morton_ind = ijk_to_x(ijk_ind, cell_props);
    [temp morton_compressed_ind] = sort(morton_ind);
    s_nodes = nodes(morton_compressed_ind,:);
    
    if plotCurves
        subplot(2,3,4);
        plot3(s_nodes(:,1), s_nodes(:,2), s_nodes(:,3),'o-');
        title('Cross (X) Order');
        axis([-1 NX -1 NX -1 NX]);
        view(max(2,DIM))
    end
    
     %% 4-node Z-order
    morton_ind = ijk_to_4node_z(ijk_ind, cell_props);
    [temp morton_compressed_ind] = sort(morton_ind);
    s_nodes = nodes(morton_compressed_ind,:);
    
    if plotCurves
        subplot(2,3,3);
        plot3(s_nodes(:,1), s_nodes(:,2), s_nodes(:,3),'o-');
        title('4-nodes per Edge (Z) Order');
        axis([-1 NX -1 NX -1 NX]);
        view(max(2,DIM))
    end
    
end

