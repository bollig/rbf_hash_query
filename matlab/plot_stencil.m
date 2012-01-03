
function plot_stencil(j, stencils, nodes, props)
dim = props.dim;
aspect_ratio = [1 1 1];
hold on;
stencil = stencils(j,1:end);
x_j = nodes(stencil(1),:);
max_rad = 0;
for i = 1:length(stencil)
    x_i = nodes(stencil(i), :);
    segment = [x_i; x_j];
    
    rad = sqrt((x_i - x_j) * (x_i - x_j)');
    if (max_rad < rad)
        max_rad = rad;
    end
    if (dim < 3)
        plot(segment(:,1), segment(:,2), 'r-', 'LineWidth', 2);
        plot(x_i(1), x_i(2),'o', 'LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','y','MarkerSize',6);
        plot(x_j(1), x_j(2),'s', 'LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','g','MarkerSize',8);
    else
        plot3(segment(:,1), segment(:,2), segment(:,3), 'r-', 'LineWidth', 2);
        plot3(x_i(1), x_i(2), x_i(3),'o', 'LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','y','MarkerSize',6);
        plot3(x_j(1), x_j(2), x_j(3),'s', 'LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','g','MarkerSize',8);
    end
end

if (dim < 3)
    [c_x, c_y, c_z] = cylinder(max_rad, 200);
    % draw circe centered at stencil center
    plot(c_x(1,:)+x_j(1), c_y(1,:)+x_j(2), '--m');
    ti = sprintf('Stencil %d', j);
    title(ti);
    axis square;
    axis([props.xmin props.xmax props.ymin props.ymax]);
    pbaspect(aspect_ratio)
else
    [c_x,c_y,c_z] = sphere(20);
    c_x = max_rad * c_x + x_j(1);
    c_y = max_rad * c_y + x_j(2);
    c_z = max_rad * c_z + x_j(3);
    sp1 = surf(c_x, c_y, c_z);
    %alpha(0.5);
    alpha = 0.2;
    set(sp1,'EdgeColor',[0.5 0.5 0.5], 'EdgeAlpha', alpha,...
        'FaceColor','m', 'FaceLighting','phong',...
        'FaceAlpha',alpha/2);
    ti = sprintf('Stencil %d', j);
    title(ti);
    axis square;
    axis([props.xmin props.xmax props.ymin props.ymax props.zmin props.zmax]);
    pbaspect(aspect_ratio)
end

hold off;
% sleep until a key is pressed
%end
end