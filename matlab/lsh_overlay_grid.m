
function [cell_hash_ind, node_ijk_hashes, cell_props] = lsh_overlay_grid(node_list, hnx, index_func, dim)

global debug;


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
    dim = dim - 1;
    hny = 1;
end
if (zmax-zmin) > 1e-8
    aspect = (zmax-zmin)/(xmax-xmin);
    hnz = ceil(hnx * aspect);
else
    dim = dim - 1;
    hnz = 1;
end

% Cell delta X, Y, Z (span of each cell)
cdx = (xmax - xmin) / hnx;
cdy = (ymax - ymin) / hny;
cdz = (zmax - zmin) / hnz;

% Foreach node:
%     determine hashid (cellid)
%          node(x,y,z) exists in cellid((x-xmin)/dx, (y-ymin)/dy, (z-zmin)/dz)
%     Convert hashid (xc, yc, zc) to some space filling curve:
%          - We could linearize cellid(xc, yc, zc) = ((xc*NY) + yc)*NZ + zc
%          - Or we could use a morton order, u-order, etc.

% xc, yc and zc are the (x,y,z) corresponding to the cell id
% xmin,ymin,zmin are member properties of the Grid class
% cdx,cdy,cdz are the deltaX, deltaY, deltaZ for the cell overlays
% TODO: we note that the xc, yc and zc can be treated at binary digits
% to select the CELL_ID (do we really need an optimization like that
% though?)
xc = floor((node_list(:,1) - xmin) / cdx);

% This logic saves us when our nodes lie on xmax, ymax, or zmax
% so instead of covering [n-1*dx,xmax)***, our cell covers
% [n-1*dx,xmax]***
% NOTE the change of bracket
xc(xc == hnx) = xc(xc == hnx) - 1;

if (cdy > 0)
    yc = floor((node_list(:,2) - ymin) / cdy);
    yc(yc == hny) = yc(yc == hny) - 1;
else
    yc = zeros(size(xc));
end
if (cdz > 0)
    zc = floor((node_list(:,3) - zmin) / cdz);
    zc(zc == hnz) = zc(zc == hnz) - 1;
else
    zc = zeros(size(xc));
end

% This is the actual hash value of our node. LSH has 3 independent hash
% functions, but we can combine them into one below.
node_ijk_hashes = [xc, yc, zc];

%cell_ijk = ((xc.*hny) + yc).*hnz + zc;

% KEY: this is how we get our index for the 3D overlay grid cell
% ZERO based cell_id (we adjust by adding 1);
cell_hash_ind = index_func(node_ijk_hashes, dim);

if debug
    if dim==2
        %% Draw only unique rectangles
        recs = unique([xmin+xc*cdx,ymin+yc*cdy,cdx*ones(size(xc)),cdy*ones(size(xc))], 'rows');
        for i = 1:size(recs,1)
            rectangle('Position',recs(i,:),'LineStyle',':','FaceColor','y');
        end
    else
        recs = unique([xmin+xc*cdx, ymin+yc*cdy, zmin+zc*cdz],'rows');
        for i = 1:size(recs)
            %% Coord of one vertex.
            x1 = recs(i,1);
            y1 = recs(i,2);
            z1 = recs(i,3);
            x2 = x1+cdx;
            y2 = y1+cdy;
            z2 = z1+cdz;
            vert = [x1 y1 z1;
                x1 y2 z1;
                x2 y2 z1;
                x2 y1 z1;
                x1 y1 z2;
                x1 y2 z2;
                x2 y2 z2;
                x2 y1 z2];
            fac = [1 2 3 4; ...
                2 6 7 3; ...
                4 3 7 8; ...
                1 5 8 4; ...
                1 2 6 5; ...
                5 6 7 8];
            patch('Faces',fac,'Vertices',vert,'FaceColor','y');  % patch function
            material shiny; 
            alpha('color'); 
            alphamap('spin'); 
        end
        light('Position',[1 3 2]);
        light('Position',[-3 -1 3]);
        camlight(45,45);
        lighting phong
        view(3);
    end
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
cell_props.dim = dim; 
end
