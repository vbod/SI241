function [peaks_grid1,peaks_grid2,linesH_grid] = find_best_pair_lines2(lines_grid_num, linesH, img_gray, edges, theta_rot, rho, peaks_rot, tol_peaks_in_line, tol_in_line_in_img, tol_var_in_line_wrt_max)
lines_to_check = unique(lines_grid_num(:));

for i = 1:size(lines_to_check,1)
    num_line = lines_to_check(i);
    peaks_in_line{num_line} = find_peaks_in_lineH(linesH(num_line), peaks_rot, tol_peaks_in_line);
    var_in_lines{num_line} = var_line_in_img(img_gray, edges, theta_rot, rho, peaks_in_line{num_line}, tol_in_line_in_img);
end

score_grids = zeros(size(lines_grid_num,1),1);
for i = 1:size(lines_grid_num)
    num_line1 = lines_grid_num(i,1); num_line2 = lines_grid_num(i,2);
    score_grids(i) = sum(var_in_lines{num_line1})+ sum(var_in_lines{num_line2});
end
[~,index] = min(score_grids);
num_line1 = lines_grid_num(index,1); num_line2 = lines_grid_num(index,2);
linesH_grid = [linesH(num_line1),linesH(num_line2)];

peaks_grid1 = [];
for i = 1:size(peaks_in_line{num_line1},1)
    tol_var_in_line = tol_var_in_line_wrt_max * min(var_in_lines{num_line1});
    if var_in_lines{num_line1}(i) < tol_var_in_line
        peaks_grid1 = [peaks_grid1;peaks_in_line{num_line1}(i,:)];
    end
end

peaks_grid2 = [];
for i = 1:size(peaks_in_line{num_line2},1)
    tol_var_in_line = tol_var_in_line_wrt_max * min(var_in_lines{num_line2});
    if var_in_lines{num_line2}(i) < tol_var_in_line
        peaks_grid2 = [peaks_grid2;peaks_in_line{num_line2}(i,:)];
    end
end

end




function var_in_lines = var_line_in_img(img_gray, edges, theta_rot, rho, peaks, tol_in_line_in_img)
lines = houghlines(edges, theta_rot, rho, peaks,'FillGap',1000);

Nlines = length(lines);

% Cacculate the normal direction of each line
normaldir = zeros(Nlines,2);
for k = 1:Nlines
    dir = lines(k).point2 - lines(k).point1;
    normaldir(k,1) = dir(2); normaldir(k,2) = -dir(1);
    normaldir(k,:) = normaldir(k,:)/norm(normaldir(k,:));
end

% Zoom on the line in the image and compute the variance near the line
var_in_lines = zeros(length(lines),1);
for k = 1:Nlines
    val_pixels_in_line = [];
    for x = 1:size(img_gray,2)
        for y = 1:size(img_gray,1)
            vec = [x,y] - lines(k).point1;
            val = abs(normaldir(k,:)*vec');
            if val < tol_in_line_in_img
                val_pixels_in_line = [val_pixels_in_line, img_gray(y,x)];
            end
        end
    end
    val_pixels_in_line = double(val_pixels_in_line);
    var_in_lines(k) = var(val_pixels_in_line);
end


end