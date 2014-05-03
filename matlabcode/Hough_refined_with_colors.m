function Hough_refined_with_colors(img, edges, theta_rot, rho, peaks_grid, res)
% Parameters
width_line = 1;
Niter_Kmeans = 100;
K = 5;
tol_color = 10;

pixels_in_lines = find_pixels_in_lines(img, edges, theta_rot, rho, peaks_grid, width_line);
size(pixels_in_lines)
[mu,~,biggest_cluster] = K_meansplusplus (pixels_in_lines, K, Niter_Kmeans);

color_line = round(mu(:,biggest_cluster));

L = 100;
color_square = uint8(cat(3,color_line(1)*ones(L,L),color_line(2)*ones(L,L),color_line(3)*ones(L,L)));
figure
imshow(color_square)

color_line = uint8(color_line);

grid = img;
for i = 1:size(img,1)
    for j = 1:size(img,2)
        color_like = norm(double(reshape(img(i,j,:),3,1) - color_line));
        if color_like <= tol_color
            grid(i,j,:) = 0;
        end
    end
end

figure
imshow(grid)




end

function pixels_in_lines = find_pixels_in_lines(img, edges, theta_rot, rho, peaks, width_line)
lines = houghlines(edges, theta_rot, rho, peaks,'FillGap',1000);

Nlines = length(lines);

% Zoom on the lines in the image
normaldir = zeros(Nlines,2);
for k = 1:Nlines
    dir = lines(k).point2 - lines(k).point1;
    normaldir(k,1) = dir(2); normaldir(k,2) = -dir(1);
    normaldir(k,:) = normaldir(k,:)/norm(normaldir(k,:));
end

pixels_in_lines = [];
for x = 1:size(img,2)
    for y = 1:size(img,1)
        val = zeros(Nlines,1);
        for k = 1:Nlines
            vec = [x,y] - lines(k).point1;
            val(k) = abs(normaldir(k,:)*vec');
        end
        if min(val) < width_line
            pixels_in_lines = [pixels_in_lines, reshape(img(y,x,:),3,1)];
        end
    end
end
pixels_in_lines = double(pixels_in_lines);

end

