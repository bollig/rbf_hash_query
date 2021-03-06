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

input_stencils = sprintf('stencils_maxsz%d_%s', n, input_grid);
input_avg_radii = sprintf('avg_radii_%s', input_grid);
input_min_radii = sprintf('min_radii_%s', input_grid);
input_max_radii = sprintf('max_radii_%s', input_grid);

node_list = dlmread(input_grid);
orig_stens = dlmread(input_stencils);

orig_avg_radii = dlmread(input_avg_radii);
orig_min_radii = dlmread(input_min_radii);
orig_max_radii = dlmread(input_max_radii);

% Get sorted values back to 0 origin
N = size(orig_stens, 1);

if strcmp(func2str(new_order_func), 'rcm')
    A = spalloc(N, N, n * N);
    %B = spalloc(N, N, n * N);
    I=[];
    J=[];
    V=[];
    for i = 1:N
        nel = size(orig_stens(i,2:end),2);
        I = [I; i * ones(nel,1)];
        J = [J; orig_stens(i,2:end)' + 1];
        V = [V; ones(nel,1)];
        %B(i,orig_stens(i,2:end)+1) = 1;
    end
    A = sparse(I,J,V,N,N);
    
    s_ind = symrcm(A);
    %ordered_A = A(s_ind,s_ind);
    %         spy(A);
    %         pause;
    %         spy(ordered_A);
else
    
    % cell_hashes are a collection of bins for each cell indicating which node
    % indices lie within each cell.
    [cell_hashes, cell_ijk, cell_props] = lsh_overlay_grid(node_list, hnx, new_order_func, dim);
    
    
    %% Sort our nodes according to the cell hashes. Does not sort within the
    %% cells!
    [sorted_hashes s_ind] = sort(cell_hashes);
end

B = spalloc(N,N,n*N);
I = [];
J = [];
V = [];
for i = 1:N
    nel = size(orig_stens(i,2:end),2);
    I = [I; i * ones(nel,1)];
    J = [J; orig_stens(i,2:end)' + 1];
    V = [V; ones(nel,1)];
    %B(i,orig_stens(i,2:end)+1) = 1;
end
B = sparse(I,J,V,N,N);


[i,j] = find(B);
bw_before = max(i-j) + 1
%spy(B)
%pause
[i,j] = find(B(s_ind,s_ind));
bw_after = max(i-j) + 1
%spy(B(s_ind, s_ind));

sorted_nodes = node_list(s_ind,:);

unsorted = 1:N;
newInd(s_ind) = unsorted;

% Get sorted values back to 0 origin
N = size(orig_stens, 1);
sorted_stens = orig_stens;
for i = 1:N
    %    add 1 because input stencils start at 0.
    old_j = orig_stens(i, 2:end) + 1;
    %    subtract 1 at end for same reason
    sorted_stens(newInd(i), 2:n+1) = newInd(old_j) - 1;
end

output_ind = sprintf('%s/%s_ind.ascii', output_dir, func2str(new_order_func))
writeToFile(output_ind, s_ind, ' ');
output_bw = sprintf('%s/%s_bw.txt', output_dir, func2str(new_order_func))
writeToFile(output_bw, [bw_before, bw_after], ' ');

output_grid = sprintf('%s/%s', output_dir, input_grid)
writeToFile(output_grid, sorted_nodes, ' ', 1);
output_stencils = sprintf('%s/%s', output_dir, input_stencils)
writeToFile(output_stencils, sorted_stens, ' ');
output_avg_radii = sprintf('%s/%s', output_dir, input_avg_radii)
writeToFile(output_avg_radii, orig_avg_radii(s_ind), ' ', 1);
output_min_radii = sprintf('%s/%s', output_dir, input_min_radii)
writeToFile(output_min_radii, orig_min_radii(s_ind), ' ', 1);
output_max_radii = sprintf('%s/%s', output_dir, input_max_radii)
writeToFile(output_max_radii, orig_max_radii(s_ind), ' ', 1);


if 0
    c = dlmread(output_stencils)
    b = dlmread(output_grid)
    for i = 1:N
        g=c(i,2:end)+1;
        plot3(b(:,1), b(:,2), b(:,3), 'r--');
        hold on;
        plot3(b(g',1), b(g',2), b(g',3), 'g.');
        plot3(b(g(1),1), b(g(1),2), b(g(1),3), 'bo');
        hold off;
        pause
    end
end

end

function [] = writeToFile(fname, data, delimiter, isDouble)

if nargin < 4
    isDouble = 0;
end
[M N] = size(data);

fid = fopen(fname, 'wt');
if isDouble
    for i = 1:M
        for j = 1:N
            fprintf(fid, '%g%s', data(i,j),delimiter);
        end
        fprintf(fid, '\n');
    end
else
    for i = 1:M
        for j = 1:N
            fprintf(fid, '%d%s', data(i,j),delimiter);
        end
        fprintf(fid, '\n');
    end
end
fclose(fid);

end