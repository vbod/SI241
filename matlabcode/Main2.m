clear all
close all
% Parameters


% Load images
res = 512; % Résolution de l'image
[img,img_gray] = load_image('tigre.jpg',res)  ;

% Detect edges
edges = edge(img_gray,'canny');
figure('name','contours')
imshow(edges)


% Hough Transform with only maxima (binary image) with optimal window in theta
[H_rot,Hbin_rot,theta_rot,rho,peaks_rot,offset] = Hough_basic2(edges,res);

peaks_rot = delete_artefacts(H_rot, peaks_rot, theta_rot);
Hbin_rot = zeros(size(H_rot)); mask = peaks_rot(:,1) + size(H_rot,1)*(peaks_rot(:,2)-1); Hbin_rot(mask) = 255;

disp_lines_in_Hough(H_rot,peaks_rot,Hbin_rot);

% First detection of a simple
[peaks_grid,linesH] = Hough_lines2_slidwind(H_rot,peaks_rot,theta_rot,res);

% Refinement of the grid
% Hough_refined_with_morhpo(img_gray,peaks_grid,theta_rot)

% peaks_grid = [peaks_grid{1};peaks_grid{2}];
% Hough_refined_with_colors(img, edges, theta_rot, rho, peaks_grid, res)



% Visualization of the lines at different steps
peaks_grid = [peaks_grid{1};peaks_grid{2}];
lines = houghlines(edges, theta_rot, rho, peaks_grid,'FillGap',100);
disp_lines_in_img(img_gray,lines)