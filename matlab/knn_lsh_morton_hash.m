function [hash_indices] = knn_lsh_morton_hash(nodes, stencil_size)
%% generate k-NN stencils following the algorithms proposed by
% Connor and Kumar, "Fast Construction of k-Nearest Neighbor Graphs for Point
% Clouds" (2009).
%

%% Step 1: Sort nodes according to Morton Ordering comparison operator
%
%   NOTE: unfortunately, matlab does not allow generalized sorting given a
%   function handle for the compare operator (see STL for this type of
%   code). Therefore, use the generalized quicksort provided by Nathan
%   Thern under the BSD license. See the 'quicksort' subdirectory for
%   license details.
addpath('./quicksort');

hash_indices = quicksort(nodes, @morton_compare_func);
sorted_nodes = nodes(hash_indices,:)


%% This will sort structs. All we have to do is make sure the "value" is our
% z-index. Unlike STL, matlab sorts static data. STL allows us to sort as
% we insert data.
%[unused, order] = sort([old_struct(:).value]);
%new_struct = old_struct(order);



end

