function [stencils] = knn_overlay_query(nodes, morton_ind, ijk_ind, cell_props, max_st_size)

nb_nodes = size(nodes,1); 
stencils = zeros(nb_nodes, max_st_size);

%% For each stencil: 


% Foreach node:
%      Generate a stencil:
%          append cell_hash[cellid(this->node)] list to candidate list
%          if (stencil_size > cell_hash.length) then
%              append 8 (or 26 if 3D) neigboring cell_hash lists to candidate list
%          end
%          sort the candidate list according to distance from node
%          select stencil_size closest matches
for  p = 1:nb_nodes
   
    cell_ind = ijk_ind(p,:);
    
    query_cell_ind = morton(p); 
    
   % nodes_in_query_cells = nodes(find(morton
    
    %% List of node candidates for nearest neighbors
    nb_neighbors_lt_r = count(; 
    
    
    % List of cell indices we will check
    % NOTE: in C++ we leverage std::set<size_t> here because it does NOT allow duplicates,
    % so cells are not searched twice. In Matlab we need to use 'unique' to
    % remove duplicates:
    %       [junk,index] = unique(y,'first');        %# Capture the index, ignore junk
    %        y = y(sort(index))
    % In reality, this can be further optimized by NOT appending
    % previous cells. However, this step does not cost a lot of
    % overhead for current applications.
    neighbor_cell_set = [];
    
    % Generate a list of cells to check for nearest neighbors
    % For each node expand the search until the max_st_size can be satisifed
    % DO NOT check cells with 0 node inside
    nb_neighbor_nodes_to_check = 0;
    level = 0;
    
    % TODO: cut-off search if (max_st_radius+cdx) is execeeded
    %          (requires a working impl of max_st_radius)o
    while (nb_neighbors_lt_r < max_st_size)
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
        
        % Now count the number of nodes we'll be checking.
        % If its greater than max_st_size then we can stop expanding
        % search
        nb_neighbor_nodes_to_check = 0;
        
        %NOTE: might need a +1 here:
        for xindx = 0-xlevel : 0+xlevel
            for yindx = 0-ylevel : 0+ylevel
                for zindx = 0-zlevel : 0+zlevel
                    % Offset cell
                    xc_o = (cell_ind(1) + xindx);
                    yc_o = (cell_ind(2) + yindx);
                    zc_o = (cell_ind(3) + zindx);
                    
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
                    
                    
                    %cell_id = ((xc_o*cell_props.hny) + yc_o)*cell_props.hnz + zc_o + 1;
                    
                    % only bother appending neighboring cells that contain
                    % nodes.
                    % gets all node ids contained in the cell
                    l = sum(cell_hash(cell_id,:) > 0);
                    if (l > 0)
                        %neighbor_cell_set.insert(cell_id);
                        level_neighbor_set(end+1) = cell_id;
                        nb_neighbor_nodes_to_check = nb_neighbor_nodes_to_check + l;
                    end
                end
            end
        end
        
        %
        %         for it = 1:length(level_neighbor_set)
        %             cell_id = level_neighbor_set(it);
        %             nb_neighbor_nodes_to_check = nb_neighbor_nodes_to_check + length(cell_hash(cell_id,:));
        %         end
        
        % Increase our search radius
        level = level + 1;
    end
    
    % This removes duplicates and keeps the id's ordered in the fashion
    % they were first appended to the list (helps minimize shuffling of
    % nearest neighbor indices)
    [junk,srt_index] = unique(level_neighbor_set,'first');        %# Capture the index, ignore junk
    %fprintf('NODE: %f %f %f is in CELL: %d and Querying %d distances in these CELLs:\n', node(1), node(2), node(3), node_cell_id, nb_neighbor_nodes_to_check);
    neighbor_cell_set = level_neighbor_set(sort(srt_index));
    
    % Compute distances for each neighbor and insert them into a sorted set.
    dists = [];
    neighbor_indx = [];
    d_count = 0;
    for it = 1:length(neighbor_cell_set)
        cell_id = neighbor_cell_set(it);
        for q = 1:length(cell_hash(cell_id,:))
            nid = cell_hash(cell_id,q);
            % Matlab appends 0's to all columns as we expand a list
            if nid == 0
                break;
            end
            neighbor = sorted_nodes(nid,:);
            sep =(node - neighbor);
            dist = sqrt(sep*sep');
            dists(end+1) = dist;
            neighbor_indx(end+1) = nid;
            d_count = d_count+1;
        end
    end
    [srted_dists, dsrt_indx] = sort(dists);
    
    % Finally, lets keep only the first max_st_size indices as our stencil
    %    stencils(p,1) = max_st_size;
    %    stencils(p,2:end) = neighbor_indx(dsrt_indx(1:max_st_size));
    stencils(p,1:end) = neighbor_indx(dsrt_indx(1:max_st_size));
    
end
end