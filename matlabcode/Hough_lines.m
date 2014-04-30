function [linesH_grid, peaks_grid1, peaks_grid2] = Hough_lines(img_gray, edges, Hbin_rot, theta_rot, rho, peaks_rot)
% Parameters to detect peaks
Nlines = 20;
threshold_hough = 0.2;
tolerance_orientation_line_in_Hough = 30;
tolerance_peaks_in_line = 2;
tolerance_line_at_90 = 10;
tolerance_in_line_in_img = 1;

% Hough Transform of Hough Transform
[HP,thetaP,rhoP] = hough(Hbin_rot,'RhoResolution',1,'Theta',-90:0.1:89.5);

% Detect peaks and lines in Hough Transform
peaksP  = houghpeaks(HP, Nlines, 'Threshold', threshold_hough*max(HP(:)));


% If the line of peaks is not enough vertical it cannot be a grid
goodpeaksP =[];
for i = 1:size(peaksP,1)
    if abs(thetaP(peaksP(i,2)))<tolerance_orientation_line_in_Hough
        goodpeaksP = [goodpeaksP;peaksP(i,:)];
    end
end

% Detect lines with the goodpeaks
linesH = houghlines(Hbin_rot, thetaP, rhoP, goodpeaksP,'FillGap',1000);

% Detect pair of lines which could represent a grid
lines_grid_num = lines_for_grid_at_90(linesH, theta_rot, peaks_rot, tolerance_peaks_in_line, tolerance_line_at_90);


% If the pair of lines could form a grid they must not vary too much on the
% image
score_grids = find_best_pair_lines(lines_grid_num, linesH, img_gray, edges, theta_rot, rho, peaks_rot, tolerance_peaks_in_line, tolerance_in_line_in_img);
[~,index] = min(score_grids);

a = lines_grid_num(index,1); b = lines_grid_num(index,2);
linesH_grid = [linesH(a),linesH(b)];

peaks_grid1 = find_peaks_in_lineH(linesH(a), peaks_rot, tolerance_peaks_in_line);
peaks_grid2 = find_peaks_in_lineH(linesH(b), peaks_rot, tolerance_peaks_in_line);


% Visualizations
HPviz = imresize(HP,[size(HP,2),size(HP,2)]); HPviz = 255*(HPviz - min(min(HPviz))*ones(size(HPviz)))/(max(max(HPviz))-min(min(HPviz)));
figure('name','HoughTransform of HoughTransform'); imshow(uint8(HPviz)), hold on

peaksPviz = peaksP; peaksPviz(:,1) = floor(peaksP(:,1)*(size(HP,2)/size(HP,1)));
x = peaksPviz(:,2); y = peaksPviz(:,1);
plot(x,y,'s','color','white');

disp_lines_in_img(Hbin_rot,linesH)
end
