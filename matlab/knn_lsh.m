function [stencils, sorted_nodes, cell_hash, cell_props] = knn_lsh(node_list, max_st_size, hnx, sort_fun)

nb_nodes = size(node_list,1);

% cell_hashes are a collection of bins for each cell indicating which node
% indices lie within each cell.
[cell_hashes, cell_props] = lsh_overlay_grid(node_list, nb_nodes, hnx);

% Now we sort our cells (approximately sort the nodes)
[cell_sorted_indices, sorted_nodes] = lsh_raster_sort(cell_hashes, node_list, nb_nodes, hnx);

[stencils] = lsh_knn_query(sorted_nodes, cell_hash, cell_props, node_list, nb_nodes, hnx, max_st_size);

end

