
function [sorted_nodes] = lsh_raster_sort(cell_hash, node_list, nb_nodes, hnx)
indx = 1;
sorted_nodes = node_list; %zeros(size(node_list));
if 0
    for i =1:size(cell_hash, 1)
        for j = 1:length(cell_hash(i,:))
            nid = cell_hash(i,j);
            % avoid 0's at the end of every row
            if nid == 0
                break;
            end
            sorted_nodes(indx,:) = node_list(nid,:);
            cell_hash(i,j) = indx;
            indx = indx + 1;
        end
    end
end
end