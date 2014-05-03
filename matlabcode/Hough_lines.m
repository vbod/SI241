function [linesH_grid, peaks_grid1, peaks_grid2] = Hough_lines(img_gray, H_rot, Hbin_rot, theta_rot, rho, peaks_rot)
% Parameters to detect peaks
Nlines = 2;
threshold_hough = 0.2;
tol_orientation_line_in_Hough = 30; % in degrees
tol_peaks_in_line = 50; % in degrees in lines in Hough
tol_line_at_90 = 30; % in degrees in linesH
tol_in_line_in_img = 2;
tol_var_in_line_wrt_max = 5;

% Hough Transform of Hough Transform
[HP,thetaP,rhoP] = hough(Hbin_rot,'RhoResolution',1,'Theta',-90:0.1:89.5);

% Detect peaks and lines in Hough Transform
peaksP  = houghpeaks(HP, Nlines, 'Threshold', threshold_hough*max(HP(:)));

% If the line of peaks is not enough vertical it cannot be a grid
goodpeaksP =[];
for i = 1:size(peaksP,1)
    if abs(thetaP(peaksP(i,2)))<tol_orientation_line_in_Hough
        goodpeaksP = [goodpeaksP;peaksP(i,:)];
    end
end

% Detect lines with the goodpeaks
linesH = houghlines(Hbin_rot, thetaP, rhoP, goodpeaksP,'FillGap',1000);

% Detect pair of lines which could represent a grid
lines_grid_num = lines_for_grid_at_90(linesH, theta_rot, peaks_rot, tol_peaks_in_line, tol_line_at_90);


% If the pair of lines could form a grid they must not vary too much on the
% image
% score_grids = find_best_pair_lines(lines_grid_num, linesH, img_gray, edges, theta_rot, rho, peaks_rot, tolerance_peaks_in_line, tolerance_in_line_in_img);
% [~,index] = min(score_grids);
% 
% a = lines_grid_num(index,1); b = lines_grid_num(index,2);
% linesH_grid = [linesH(a),linesH(b)];
% 
% peaks_grid1 = find_peaks_in_lineH(linesH(a), peaks_rot, tolerance_peaks_in_line);
% peaks_grid2 = find_peaks_in_lineH(linesH(b), peaks_rot, tolerance_peaks_in_line);

% [peaks_grid1,peaks_grid2,linesH_grid] = find_best_pair_lines2(lines_grid_num, linesH, img_gray, edges, theta_rot, rho, peaks_rot, tol_peaks_in_line, tol_in_line_in_img, tol_var_in_line_wrt_max);

% num_line1 = lines_grid_num(1,1); num_line2 = lines_grid_num(1,2);
num_line1 = 1; num_line2 = 2;
linesH_grid = [linesH(1),linesH(2)];
peaks_grid1 = find_peaks_in_lineH(linesH(num_line1), peaks_rot, tol_peaks_in_line);
peaks_grid2 = find_peaks_in_lineH(linesH(num_line2), peaks_rot, tol_peaks_in_line);

% Visualizations
HPviz = imresize(HP,[size(HP,2),size(HP,2)]); HPviz = 255*(HPviz - min(min(HPviz))*ones(size(HPviz)))/(max(max(HPviz))-min(min(HPviz)));
figure('name','HoughTransform of HoughTransform'); imshow(uint8(HPviz)), hold on

peaksPviz = peaksP; peaksPviz(:,1) = floor(peaksP(:,1)*(size(HP,2)/size(HP,1)));
x = peaksPviz(:,2); y = peaksPviz(:,1);
plot(x,y,'s','color','white');


figure('name','Lines in Hough')
imshow(uint8(H_rot)), hold on;

peaksviz = peaks_rot;
% peaksviz(:,1) = floor(peaks_rot(:,1)*(size(H_rot,2)/size(H_rot,1)));
x = peaksviz(:,2); y = peaksviz(:,1);
plot(x,y,'s','color','red'), hold on;

for k = 1:length(linesH)
   xy = [linesH(k).point1; linesH(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',4,'Color','green');
   
   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
end

end

