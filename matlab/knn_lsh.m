function [stencils, sorted_nodes, cell_hashes, cell_props] = knn_lsh(node_list, max_st_size, hnx, sort_fun)


debug = 1; 

if debug
hold on 
plot(node_list(:,1), node_list(:,2), 'r.--'); 
end

nb_nodes = size(node_list,1);

% cell_hashes are a collection of bins for each cell indicating which node
% indices lie within each cell.
[cell_hashes, cell_ijk, cell_props] = lsh_overlay_grid(node_list, nb_nodes, hnx, sort_fun);

% Now we sort our cells (approximately sort the nodes)
fprintf('ERROR INCOMPLETE'); 


[temp s_ind] = sort(cell_hashes);
sorted_nodes = node_list(s_ind,:);
sorted_cell_ijk = cell_ijk(s_ind,:); 


%[sorted_nodes] = lsh_raster_sort(cell_ijk, node_list, nb_nodes, hnx);

if debug
    plot(sorted_nodes(:,1), sorted_nodes(:,2), '-o');
   hold off;  
end

stencils = 0; 

%[stencils] = lsh_knn_query(sorted_nodes, sorted_cell_ijk, cell_props, node_list, nb_nodes, hnx, max_st_size);
%[stencils] = lsh_knn_query(sorted_nodes, cell_hashes, cell_props, node_list, nb_nodes, hnx, max_st_size);

end

