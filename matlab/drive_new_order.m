function [] = drive_new_order(input_grid, n, dim, hnx, new_order_func)
	global debug; 
	debug = 0; 

	% ORIGINAL FILES: 
	% input_grid.ascii 
	% stencils_maxsz50_input_grid.ascii
	% avg_radii_input_grid.ascii  
	% max_radii_input_grid.ascii  
	% min_radii_input_grid.ascii  

	% (Ignore:) 
	% bndry_input_grid.ascii      
	% metis_stencils.graph
	% nrmls_input_grid.ascii 
	% time_log.stencils
	% 1) make new directory
	% 2) reorder grid
	%  (stencils should stay the same given the same $n$
			% 3) write grid to "new_order_func_name"  

	% OUTPUT FILES: 
	output_dir = sprintf('reordered_%s', func2str(new_order_func))
	mkdir(output_dir)

	node_list = dlmread(input_grid);
	%	orig_stens = dlmread(sprintf('stencils_maxsz%d_%s', n, input_grid);

	% spy_stencils(orig_stens);

	% cell_hashes are a collection of bins for each cell indicating which node
	% indices lie within each cell.
	[cell_hashes, cell_ijk, cell_props] = lsh_overlay_grid(node_list, hnx, new_order_func, dim);


	%% Sort our nodes according to the cell hashes. Does not sort within the
	%% cells!
	[sorted_hashes s_ind] = sort(cell_hashes);
	sorted_nodes = node_list(s_ind,:);

	dlmwrite(sprintf('%s/%s', output_dir, input_grid), sorted_nodes); 
	%dlmwrite(sprintf('%s/%s', output_dir, input_stencils), orig_stens(s_ind,s_ind)); 

end

function[] = reorder_stens()

	N = size(stencil_list, 1); 
	st = size(stencil_list,2); 
	A = spalloc(N, N, st * N);
	for i = 1:N
	    for j = 1:st
		A(i,stencil_list(i,j)) = 1; 
	    end
	end
end
