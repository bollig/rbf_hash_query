
function [cell_hashes, cell_props] = lsh_overlay_grid(node_list, nb_nodes, hnx)

% Dimensions of the hash overlay grid (hnx by hny by hnz regular grid
% spanning the full bounding box of the domain extent)
% NOTE: it works best for nearest neighbor if we have square/cube cells

xmin = min(node_list(:,1));
xmax = max(node_list(:,1));

if (size(node_list, 2) > 1)
    ymin = min(node_list(:,2));
    ymax = max(node_list(:,2));
else
    ymin = 0;
    ymax = 0;
end

if (size(node_list, 2) > 2)
    zmin = min(node_list(:,3));
    zmax = max(node_list(:,3));
else
    zmin = 0;
    zmax = 0;
end
if (ymax-ymin) > 1e-8
    aspect = (ymax-ymin)/(xmax-xmin);
    hny = ceil(hnx * aspect);
else
    hny = 1;
end
if (zmax-zmin) > 1e-8
    aspect = (zmax-zmin)/(xmax-xmin);
    hnz = ceil(hnx * aspect);
else
    hnz = 1;
end

cell_hashes = zeros(hnx * hny * hnz, 1);
% list of lists
%' cell_hash.resize(hnx * hny * hnz);
cell_id_end = zeros(hnx * hny * hnz, 1);

% Cell delta X, Y, Z (span of each cell)
cdx = (xmax - xmin) / hnx;
cdy = (ymax - ymin) / hny;
cdz = (zmax - zmin) / hnz;

% Foreach node:
%     determine hashid (cellid)
%          node(x,y,z) exists in cellid((x-xmin)/dx, (y-ymin)/dy, (z-zmin)/dz)
%          linearize cellid(xc, yc, zc) = ((xc*NY) + yc)*NZ + zc
%          append node to list contained in list[cellid]
for i = 1 : nb_nodes
    node = node_list(i,:);
    % xc, yc and zc are the (x,y,z) corresponding to the cell id
    % xmin,ymin,zmin are member properties of the Grid class
    % cdx,cdy,cdz are the deltaX, deltaY, deltaZ for the cell overlays
    % TODO: we note that the xc, yc and zc can be treated at binary digits
    % to select the CELL_ID (do we really need an optimization like that
    % though?)
    xc = floor((node(1) - xmin) / cdx);
    
    % This logic saves us when our nodes lie on xmax, ymax, or zmax
    % so instead of covering [n-1*dx,xmax)***, our cell covers
    % [n-1*dx,xmax]***
    %
    if (xc == hnx)
        xc = xc-1;
    end
    
    if (cdy > 0)
        yc = floor((node(2) - ymin) / cdy);
        if (yc == hny)
            yc = yc-1;
        end
    else
        yc = 0;
    end
    if (cdz > 0)
        zc = floor((node(3) - zmin) / cdz);
        if (zc == hnz)
            zc = zc-1;
        end
    else
        zc = 0;
    end
    
    % This is the actual hash value of our node. LSH has 3 independent hash
    % functions, but we can combine them into one below. 
    node_hash = [xc, yc, zc]; 
    
    % KEY: this is how we get our index for the 3D overlay grid cell
    % ZERO based cell_id (we adjust by adding 1);
    cell_id = ((xc*hny) + yc)*hnz + zc + 1;
    
    %fprintf('NODE: %f %f %f is in CELL: %d\n', node(1), node(2), node(3), cell_id);
    
    % Push back node index on cell hash
    cell_id_end(cell_id) = cell_id_end(cell_id) + 1;
    cell_hashes(cell_id,cell_id_end(cell_id)) = i;
end

cell_props.hnx=hnx;
cell_props.hny=hny;
cell_props.hnz=hnz;
cell_props.xmin=xmin;
cell_props.xmax=xmax;
cell_props.ymin=ymin;
cell_props.ymax=ymax;
cell_props.zmin=zmin;
cell_props.zmax=zmax;
cell_props.cdx = cdx;
cell_props.cdy = cdy;
cell_props.cdz = cdz;
end
