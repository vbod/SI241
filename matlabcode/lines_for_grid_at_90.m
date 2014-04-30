function lines_grid_num = lines_for_grid_at_90(linesH,theta_rot,peaks_rot,tolerance_peaks_in_line,tolerance_line_at_90)
% If the line has no other line which is approximatively at 90° it cannot
% be a grid
approx_dir_line = zeros(length(linesH),1);
for i = 1:length(linesH)
    peaks_in_linesH = find_peaks_in_lineH(linesH(i),peaks_rot,tolerance_peaks_in_line);
    approx_dir_line(i) = mean(theta_rot(peaks_in_linesH(:,2)));
end

lines_grid_num = [];
for i = 1:length(linesH)
    for j = i+1:length(linesH)
        if abs(abs(approx_dir_line(i)-approx_dir_line(j))-90)<tolerance_line_at_90   
            lines_grid_num = [lines_grid_num;i,j];
        end
    end
end
end