function score_grids = find_best_pair_lines(lines_grid_num, linesH, img_gray, edges, theta_rot, rho, peaks_rot, tolerance_peaks_in_line, tolerance_in_line_in_img)
score_grids = zeros(size(lines_grid_num,1),1);

for i = 1:size(lines_grid_num,1)
    a = lines_grid_num(i,1); b = lines_grid_num(i,2);
    peaks = find_peaks_in_lineH(linesH(a),peaks_rot,tolerance_peaks_in_line);
    peaks = [peaks;find_peaks_in_lineH(linesH(b),peaks_rot,tolerance_peaks_in_line)];
    score_grids(i) = var_line_in_img(img_gray, edges, theta_rot, rho, peaks, tolerance_in_line_in_img);
end

end

function var_in_lines = var_line_in_img(img_gray, edges, theta_rot, rho, peaks, tolerance_in_line_in_img)
lines = houghlines(edges, theta_rot, rho, peaks,'FillGap',1000);

Nlines = length(lines);

% Zoom on the lines in the image
normaldir = zeros(Nlines,2);
for k = 1:Nlines
    dir = lines(k).point2 - lines(k).point1;
    normaldir(k,1) = dir(2); normaldir(k,2) = -dir(1);
    normaldir(k,:) = normaldir(k,:)/norm(normaldir(k,:));
end

val_pixels_in_line = [];
for x = 1:size(img_gray,2)
    for y = 1:size(img_gray,1)
        val = zeros(Nlines,1);
        for k = 1:Nlines
            vec = [x,y] - lines(k).point1;
            val(k) = abs(normaldir(k,:)*vec');
        end
        if min(val) < tolerance_in_line_in_img
            val_pixels_in_line = [val_pixels_in_line, img_gray(y,x)];
        end
    end
end
val_pixels_in_line = double(val_pixels_in_line);
var_in_lines = var(val_pixels_in_line);

end