clear all;



DIM = 3;
NX = 10;
plotCurves = 1;
testAll = 0;
if DIM == 1
    %[nodeX, nodeY, nodeZ] = meshgrid(linspace(0,1,NX),0,0);
    [nodeX, nodeY, nodeZ] = meshgrid(1:NX,0,0);
    [ijkX, ijkY, ijkZ] = meshgrid(1:NX,0,0);
elseif DIM == 2
    %[nodeX, nodeY, nodeZ] = meshgrid(linspace(0,1,NX),linspace(0,1,NX),0);
    [nodeX, nodeY, nodeZ] = meshgrid(1:NX,1:NX,0);
    [ijkX, ijkY, ijkZ] = meshgrid(1:NX,1:NX,0);
elseif DIM==3
    [nodeX, nodeY, nodeZ] = meshgrid(1:NX,1:NX,1:NX);
    % [nodeX, nodeY, nodeZ] = meshgrid(linspace(0,1,NX),linspace(0,1,NX),linspace(0,1,NX));
    [ijkX, ijkY, ijkZ] = meshgrid(1:NX,1:NX,1:NX);
else
    fprintf('Error, No support for dimensions greater than 3\n');
    return;
end

nodes = [nodeX(:), nodeY(:), nodeZ(:)];
clear nodeX nodeY nodeZ;
ijk_ind = [ijkX(:), ijkY(:), ijkZ(:)];
clear ijkX ijkY ijkZ;

%subplot(2,1,2)
% plot3(s_nodes(:,1), s_nodes(:,2), s_nodes(:,3),'o-');
% xlabel('k');
% ylabel('i');
% zlabel('j');

if plotCurves
    subplot(2,2,1);
    plot3(nodes(:,1), nodes(:,2), nodes(:,3),'o-');
    title('Original (Raster) Order');
    view(max(2,DIM))
end


%% Z-order
morton_ind = ijk_to_zz(ijk_ind, DIM, [0,1]);
[temp morton_compressed_ind] = sort(morton_ind);
s_nodes = nodes(morton_compressed_ind,:);

if plotCurves
    subplot(2,2,2);
    plot3(s_nodes(:,1), s_nodes(:,2), s_nodes(:,3),'o-');
    title('Morton (Z) Order');
    view(max(2,DIM))
end

if testAll
    
    %% U-order
    morton_ind = ijk_to_u(ijk_ind, DIM, [0,1]);
    [temp morton_compressed_ind] = sort(morton_ind);
    s_nodes = nodes(morton_compressed_ind,:);
    
    if plotCurves
        subplot(2,2,3);
        plot3(s_nodes(:,1), s_nodes(:,2), s_nodes(:,3),'o-');
        title('Gray-Code (U) Order');
        view(max(2,DIM))
    end
    
    %% X-order
    morton_ind = ijk_to_x(ijk_ind, DIM, [0,1]);
    [temp morton_compressed_ind] = sort(morton_ind);
    s_nodes = nodes(morton_compressed_ind,:);
    
    if plotCurves
        subplot(2,2,4);
        plot3(s_nodes(:,1), s_nodes(:,2), s_nodes(:,3),'o-');
        title('Cross (X) Order');
        view(max(2,DIM))
    end
end