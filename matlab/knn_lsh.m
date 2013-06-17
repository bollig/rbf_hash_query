function [stencils, sorted_nodes, sorted_hashes, cell_props] = knn_lsh(node_list, max_st_size, hnx, dim, order_func)

%% Use the KDtree to find nearest neighbors (inefficient)?
useKDTree = 0;

global debug;

if debug
    hold on
    plot3(node_list(:,1), node_list(:,2), node_list(:,3), 'r.--');
    hold off;
    pause
end

% cell_hashes are a collection of bins for each cell indicating which node
% indices lie within each cell.
[cell_hashes, cell_ijk, cell_props] = lsh_overlay_grid(node_list, hnx, order_func, dim);


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
    pause
end

if useKDTree
    addpath('kdtree')
    ktree = kdtree_build(sorted_nodes);
    
    for i = 1:size(sorted_nodes,1)
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
        q = 0;
        neighbor_candidate_count = 0;
        neighbor_candidate_list = [];
        while (neighbor_candidate_count <= max_st_size) && (q < cell_props.hnx)
            % Get this list of cells neighboring the cell_ind
            neighbor_cell_inds_rad_q = getCellNeighbors(cell_ind, center_cell_ijk, q, cell_props, order_func);
            neighbors_rad_q = 0; 
            % For each cell, append node list
            % if node list gets large enough we can break loop (only after
            % we append all nodes in radius
            for pq = 1:size(neighbor_cell_inds_rad_q)
                neighbor_cell_node_ind = getCellNodes(neighbor_cell_inds_rad_q(pq), sorted_hashes);
                neighbor_candidate_list = [neighbor_candidate_list; neighbor_cell_node_ind];
                neighbors_rad_q = neighbors_rad_q + size(neighbor_cell_node_ind,1);
            end
            neighbor_candidate_count = neighbor_candidate_count + neighbors_rad_q;
            q = q + 1;
        end
        stencils(p,:) = getNearestNeighbors(p, neighbor_candidate_list, sorted_nodes, min(neighbor_candidate_count, max_st_size));
        if debug
            hold off;
            delete(gca);
            plot_stencil(p, stencils, sorted_nodes, cell_props);
            hold on;
            plot3(sorted_nodes(:,1), sorted_nodes(:,2), sorted_nodes(:,3), '-o');
            hold off;
            pause
        end
    end
end

if debug
%    hold on;
    plot_stencil(10, stencils, sorted_nodes, cell_props);
%    hold off;
    pause
end
end

function [node_ind] = getCellNodes(hash_ind, hash_list)
% Need to get all nodes that have hash_ind (i.e., all nodes in cell
% "hash_ind"
node_ind = find(hash_list == hash_ind);

end


function [ijk_cell_inds] = getCellNeighbors(hash_ind, hash_ijk, radius, cell_props, order_func)
    if radius < 1
        ijk_cell_inds = hash_ind;
        return;
    end

    outer_cells = getAllCells(radius, hash_ijk, cell_props, order_func);
    inner_cells = getAllCells(radius-1, hash_ijk, cell_props, order_func);

    ijk_cell_inds = setdiff(outer_cells, inner_cells);
end


function [level_neighbor_set] = getAllCells(level, hash_ijk, cell_props, order_func)

%hash_ijk
%cell_props
xc = hash_ijk(1);
yc = hash_ijk(2);
zc = hash_ijk(3);

% KEY: this is how we get our index for the 3D overlay grid cell
% ZERO based cell_id (we adjust by adding 1);
node_cell_id = ((xc*cell_props.hny) + yc)*cell_props.hnz + zc + 1;
%node_cell_id = order_func([xc, yc, zc], cell_props.dim);


% List of cell indices we will check
% NOTE: in C++ we leverage std::set<size_t> here because it does NOT allow duplicates,
% so cells are not searched twice. In Matlab we need to use 'unique' to
% remove duplicates:
%       [junk,index] = unique(y,'first');        %# Capture the index, ignore junk
%        y = y(sort(index))
% In reality, this can be further optimized by NOT appending
% previous cells. However, this step does not cost a lot of
% overhead for current applications.
level_neighbor_set = [];

xlevel = level;
ylevel = 0;
zlevel = 0;
if cell_props.hny > 1
    ylevel = level;
end
if cell_props.hnz > 1
    zlevel = level;
end

% Now count the number of cells we'll be checking.
% TODO: we could check the count of nodes; If its 
% greater than max_st_size then we can stop expanding
% search
nb_neighbor_cells_to_check = 0;

% NOTE: we can add a dense grid of cells because we get the current level
% minus the previous set (to get the sparse shell)
for xindx = 0-xlevel : 0+xlevel
    for yindx = 0-ylevel : 0+ylevel
        for zindx = 0-zlevel : 0+zlevel
            % Offset cell
            xc_o = (xc + xindx);
            yc_o = (yc + yindx);
            zc_o = (zc + zindx);
            
            % If the neighbor cell is outside our overlay we ignore the task
            if ((xc_o < 0) || (xc_o >= cell_props.hnx))
                continue;
            end
            
            if ((yc_o < 0) || (yc_o >= cell_props.hny))
                continue;
            end
            
            if ((zc_o < 0) || (zc_o >= cell_props.hny))
                continue;
            end
            
            % Raster:
            cell_id = ((xc_o*cell_props.hny) + yc_o)*cell_props.hnz + zc_o + 1;
            
            % Morton/Raster: 
            cell_id = order_func([xc_o, yc_o, zc_o], cell_props.dim);
            
            % TODO: only append neighboring cells that contain
            % nodes?
            level_neighbor_set = [level_neighbor_set; cell_id];
            nb_neighbor_cells_to_check = nb_neighbor_cells_to_check + 1;
        end
    end
end

end

function [neighbors] = getNearestNeighbors(node, neighbor_candidate_list, node_coords, st_size)
    
    X = node_coords(neighbor_candidate_list,:);
    X_c = node_coords(node,:) ;
    M = size(neighbor_candidate_list,1);
    for i = 1:M
       dists(i,1) = sqrt(sum((X(i,:) - X_c).^2,2));
    end
    % Make sure we skim off the first n-neighbors
    [temp ind] = sort(dists);
    neighbors = neighbor_candidate_list(ind(1:st_size,:));
end