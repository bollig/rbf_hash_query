function[hash_indices] = quick_sort_nodes_morton(nodes)
%% Sort nodes according to Morton Ordering comparison operator
%
%   NOTE: unfortunately, matlab does not allow generalized sorting given a
%   function handle for the compare operator (see STL for this type of
%   code). Therefore, use the generalized quicksort provided by Nathan
%   Thern under the BSD license. See the 'quicksort' subdirectory for
%   license details.
addpath('./quicksort');

hash_indices = quicksort(nodes, @morton_compare_func2);
%sorted_nodes = nodes(hash_indices,:);
end