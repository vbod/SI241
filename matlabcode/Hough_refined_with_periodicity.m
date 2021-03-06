function peaks_refined = Hough_refined_with_periodicity(H_rot,linesH_grid,peaks_grid1,peaks_grid2)

peaks_grid1 = circshift(peaks_grid1,[0,1]);
per1 = Inf;
line_dir1 = linesH_grid(1).point2 - linesH_grid(1).point1; line_dir1 = line_dir1/norm(line_dir1);
for i = 1:size(peaks_grid1,1)
    for j = 1:size(peaks_grid1,1)
        if i~= j
            vec_peaks = peaks_grid1(i,:) - peaks_grid1(j,:);
            ecart = abs(vec_peaks * line_dir1');
            if ecart < per1
                per1 = ecart;
            end
        end
    end
end

peaks_grid2 = circshift(peaks_grid2,[0,1]);
per2 = Inf;
line_dir2 = linesH_grid(2).point2 - linesH_grid(2).point1; line_dir2 = line_dir2/norm(line_dir2);
for i = 1:size(peaks_grid2,1)
    for j = 1:size(peaks_grid2,1)
        if i~= j
            vec_peaks = peaks_grid2(i,:) - peaks_grid2(j,:);
            ecart = abs(vec_peaks * line_dir2');
            if ecart < per2
                per2 = ecart;
            end
        end
    end
end



peaks_grid1_seed = peaks_grid1(1,:);
peaks_grid1_refined = peaks_grid1_seed;
in_Hough = 1;
new_peak = peaks_grid1_seed;
while in_Hough
    new_peak = new_peak - per1*line_dir1; new_peak = floor(new_peak);
    val_Hough = H_rot(new_peak(2),new_peak(1));
    if val_Hough == 0
        in_Hough = 0;
    else
        peaks_grid1_refined = [peaks_grid1_refined; new_peak];
    end
end

in_Hough = 1;
new_peak = peaks_grid1_seed;
while in_Hough
    new_peak = new_peak + per1*line_dir1; new_peak = floor(new_peak);
    val_Hough = H_rot(new_peak(2),new_peak(1));
    if val_Hough == 0
        in_Hough = 0;
    else
        peaks_grid1_refined = [peaks_grid1_refined; new_peak];
    end
end



peaks_grid2_seed = peaks_grid2(1,:);
peaks_grid2_refined = peaks_grid2_seed;
in_Hough = 1;
new_peak = peaks_grid2_seed;
while in_Hough
    new_peak = new_peak - per1*line_dir2; new_peak = floor(new_peak);
    val_Hough = H_rot(new_peak(2),new_peak(1));
    if val_Hough == 0
        in_Hough = 0;
    else
        peaks_grid2_refined = [peaks_grid2_refined; new_peak];
    end
end

in_Hough = 1;
new_peak = peaks_grid2_seed;
while in_Hough
    new_peak = new_peak + per1*line_dir2; new_peak = floor(new_peak);
    val_Hough = H_rot(new_peak(2),new_peak(1));
    if val_Hough == 0
        in_Hough = 0;
    else
        peaks_grid2_refined = [peaks_grid2_refined; new_peak];
    end
end

peaks_grid2_refined = circshift(peaks_grid2_refined,[0,1]);


peaks_refined = [peaks_grid1_refined; peaks_grid2_refined];

Hviz = imresize(H_rot,[size(H_rot,2),size(H_rot,2)]); Hviz = 255*(Hviz - min(min(Hviz))*ones(size(Hviz)))/(max(max(Hviz))-min(min(Hviz)));
figure('name','HoughTransform')
imshow(uint8(Hviz)), hold on;

peaksviz = peaks_refined;
peaksviz(:,1) = floor(peaks_refined(:,1)*(size(H_rot,2)/size(H_rot,1)));
x = peaksviz(:,2); y = peaksviz(:,1);
plot(x,y,'s','color','red');
