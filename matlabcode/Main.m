clear all
close all
% Parameters

% Load images
scale = 512;
[img,img_gray] = load_image('tigre.jpg',scale)  ;

% Detect edges
edges = edge(img_gray,'canny');
figure('name','contours')
imshow(edges)

% % K-means color
% nb_clusters = 10;
% pixel_labels = k_means_color(img, nb_clusters);

% Hough Transform with only maxima (binary image) with optimal window in theta
[H_rot,Hbin_rot,theta_rot,rho,peaks_rot,offset] = Hough_basic(edges);

% Search lines by iterative processus
disp_lines_in_Hough(H_rot,peaks_rot,Hbin_rot);

[linesH_grid, peaks_grid1, peaks_grid2] = Hough_lines(img_gray, H_rot, Hbin_rot, theta_rot, rho, peaks_rot);
peaks_grid = [peaks_grid1; peaks_grid2];
size(peaks_grid1)
size(peaks_grid2)

% Refine to get the entire grid
% peaks_refined = Hough_refined_with_zoom(H_rot,linesH_grid);
% peaks_refined = Hough_refined_with_periodicity(H_rot,linesH_grid,peaks_grid1,peaks_grid2);

% Visualization of the lines at different steps
lines = houghlines(edges, theta_rot, rho, peaks_grid,'FillGap',1000);
disp_lines_in_img(img_gray,lines)

% lines = houghlines(edges, theta_rot, rho, peaks_refined,'FillGap',1000);
% disp_lines_in_img(img_gray,lines)

