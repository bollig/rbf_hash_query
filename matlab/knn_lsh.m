function [stencils, sorted_nodes, sorted_hashes, cell_props] = knn_lsh(node_list, max_st_size, hnx, order_func)

%% Use the KDtree to find nearest neighbors (inefficient)?
useKDTree = 0;

global debug;

if debug
    hold on
    %plot3(node_list(:,1), node_list(:,2), node_list(:,3), 'r.--');
    hold off;
end

% cell_hashes are a collection of bins for each cell indicating which node
% indices lie within each cell.
[cell_hashes, cell_ijk, cell_props] = lsh_overlay_grid(node_list, hnx, order_func);


%% Sort our nodes according to the cell hashes. Does not sort within the
%% cells!
[sorted_hashes s_ind] = sort(cell_hashes);
sorted_nodes = node_list(s_ind,:);

%% This is our map to go from the Z order cells to IJK
sorted_cell_ijk = cell_ijk(s_ind,:);

%[sorted_nodes] = lsh_raster_sort(cell_ijk, node_list, nb_nodes, hnx);

if debug
    hold on;
    plot3(sorted_nodes(:,1), sorted_nodes(:,2), sorted_nodes(:,3), '-o');
    hold off;
end

if useKDTree
    addpath('kdtree')
    ktree = kdtree_build(sorted_nodes);
    
    for i = 1:size(node_list,1)
        sten = kdtree_k_nearest_neighbors(ktree, sorted_nodes(i,:), max_st_size);
        % reverse order
        stencils(i,:) = sten(end:-1:1);
    end
else
    
    % For each stencil: 
    % Get center node (centers == sorted_nodes(:,:))
    % Hash center node to cell index (ind == sorted_hashes or ind == sorted_cell_ijk)
    % Start circular search by getting ijk of neighboring cells and
    % converting them to z-order.
    
    if debug
       %% SHOW cells included in search as red 
    end
    
    for  p = 1:size(sorted_nodes,1)
        % Start at center
        center_cell_ijk = sorted_cell_ijk(p,:);
        
        % Append all nodes in center cell to list
        nodes_in_cell =1; 
    end
    
    
    %[stencils] = knn_overlay_query(sorted_nodes, sorted_hashes, sorted_cell_ijk, cell_props, max_st_size);
end

if debug
    hold on;
    plot_stencil(10, stencils, sorted_nodes, cell_props);
    hold off;
end
end
