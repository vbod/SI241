function peaks_in_linesH = find_peaks_in_lineH(linesH, peaks_rot, tolerance_peaks_in_line)
line_dir = linesH(1).point2 - linesH(1).point1; line_dir = line_dir/norm(line_dir);

peaks_rot = circshift(peaks_rot,[0,1]);
peaks_in_linesH =[];
for i = 1:length(peaks_rot)
    peaks_line = peaks_rot(i,:) - linesH(1).point1; peaks_line = peaks_line/norm(peaks_line);
    a = abs(peaks_line*line_dir'); a = acosd(a);
    if (a<=tolerance_peaks_in_line)
        peaks_in_linesH = [peaks_in_linesH; peaks_rot(i,:)];
    end
end
peaks_in_linesH = circshift(peaks_in_linesH,[0,1]);

end