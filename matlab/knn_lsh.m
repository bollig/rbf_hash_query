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
[cell_hashes, cell_ijk, cell_props] = lsh_overlay_grid(node_list, hnx, order_func)

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
    
    % For all nodes: 
    for  p = 1:size(sorted_nodes,1)
        % Start at center
        center_cell_ijk = sorted_cell_ijk(p,:);
        
        cell_ind = sorted_hashes(p); 
        
        % while list of candidates < n (required stencil size)
        %       append nodes in cells of rasterized circle of radius q
        %       q = 0 (center)
        %       q = 1 (center +/- -1:1^2 
        nodes_in_cell_ind = getCellNodes(cell_ind, sorted_hashes);
        q = 0;
        neighbor_candidate_count = 0;
        neighbor_candidate_list = [];
        while neighbor_candidate_count < max_st_size
            neighbor_cell_inds_rad_q = getCellNeighbors(cell_ind, center_cell_ijk, q, cell_props)
            neighbors_rad_q = 0; 
            for pq = 1:size(neighbor_cell_inds_rad_q)
                neighbor_cell_nodes = getCellNodes(neighbor_cell_inds_rad_q(pq), sorted_hashes)
                neighbor_candidate_list = [neighbor_candidate_list; neighbor_cell_nodes];
                neighbors_rad_q = neighbors_rad_q + size(neighbor_cell_nodes,1)
            end
            neighbor_candidate_count = neighbor_candidate_count + neighbors_rad_q
            q = q+1; 
        end
        
        neighbor_candidate_count
        neighbor_candidate_list
        % Append all nodes in center cell to list
        
    end
    
    
    %[stencils] = knn_overlay_query(sorted_nodes, sorted_hashes, sorted_cell_ijk, cell_props, max_st_size);
end

if debug
    hold on;
    plot_stencil(10, stencils, sorted_nodes, cell_props);
    hold off;
end
end

function [node_ind] = getCellNodes(hash_ind, hash_list)
% Need to get all nodes that have hash_ind (i.e., all nodes in cell
% "hash_ind"

node_ind = find(hash_list == hash_ind);

end

function [ijk_cell_inds] = getCellNeighbors(hash_ind, hash_ijk, radius, cell_props)

  hash_ijk 

 cx = hash_ijk(1);
 cy = hash_ijk(2);
 cz = hash_ijk(3);

 ijk_cell_inds = [];
 cell_props
 
 % 2D works. genearlize to 3D...
 if cell_props.dim == 2
    index_of_cell = cx * (cell_props.hnx) + (cy)

%     Test radius > 0 as failsafe
    if (radius <= 0)
        ijk_cell_inds = index_of_cell;
        return;
    end
        
%     top and bottom
    for pp = -radius:1:radius
        row = (cx - radius);
        col = (cy + pp);
        if row >= 0 && col >= 0 && row < cell_props.hnx && col < cell_props.hny
            index_of_top = row * cell_props.hnx + col;
            ijk_cell_inds = [ijk_cell_inds; index_of_top];
        end
    end

    for pp = -radius:1:radius
        row = (cx + radius);
        col = (cy + pp);
        if row >= 0 && col >= 0 && row < cell_props.hnx && col < cell_props.hny
            index_of_bottom = row * cell_props.hnx + col;
            ijk_cell_inds = [ijk_cell_inds; index_of_bottom];
        end
    end
   
%     left and right
%     NOTE: subtract 1 from index range because the cells were already
%     added by Top/Bottom
%     TODO: if left > min, if right < max
    for qq = -(radius-1):1:(radius-1)
        row = (cx + qq);
        col = (cy - radius);
        if row >= 0 && col >= 0 && row < cell_props.hnx && col < cell_props.hny
            index_of_left = row * cell_props.hnx + col;
            ijk_cell_inds = [ijk_cell_inds; index_of_left];
        end
    end
    for qq = -(radius-1):1:(radius-1)
        row = (cx + qq);
        col = (cy + radius);
        if row >= 0 && col >= 0 && row < cell_props.hnx && col < cell_props.hny
            index_of_right = row * cell_props.hnx + col;
            ijk_cell_inds = [ijk_cell_inds; index_of_right];
        end
    end
    
 else
     hash_ind
     hash_ijk
     index_of_cell = (cx * (cell_props.hnx) + cy)*(cell_props.hny) + cz

     
     
     %NOTE: might need a +1 here:
     for xindx = 0-xlevel : 0+xlevel
         for yindx = 0-ylevel : 0+ylevel
             for zindx = 0-zlevel : 0+zlevel
                 % Offset cell
%                     xc_o = (xc + xindx);
%                     yc_o = (yc + yindx);
%                     zc_o = (zc + zindx);
%                     
%                     % If the neighbor cell is outside our overlay we ignore the task
%                     if ((xc_o < 0) || (xc_o >= hnx))
%                         continue;
%                     end
% 
%                     if ((yc_o < 0) || (yc_o >= hny))
%                         continue;
%                     end
% 
%                     if ((zc_o < 0) || (zc_o >= hny))
%                         continue;
%                     end
% 
%                     cell_id = ((xc_o*hny) + yc_o)*hnz + zc_o + 1;
% 
%                     % only bother appending neighboring cells that contain
%                     % nodes.
%                     % gets all node ids contained in the cell
%                     l = sum(cell_hash(cell_id,:) > 0);
%                     if (l > 0)
%                         %neighbor_cell_set.insert(cell_id);
%                         level_neighbor_set(end+1) = cell_id;
%                         nb_neighbor_nodes_to_check = nb_neighbor_nodes_to_check + l;
%                     end
%                 end
%             end
%         end
 end
end