addpath('int_morton')

nodes = load('loadedgrid_1024nodes_final.ascii'); 

%% OLD: 
%[sten snodes] = knn_lsh_with_ijk_hash(nodes, 5, 10);

%% NEW: 
[sten snodes ch cp] = knn_lsh(nodes, 5, 10, @ijk_to_z );

spy_stencils(sten);