clear all
close all
% Parameters

% Load images
addpath('images')
img = imread('DSCN2645.jpg');
img_gray = rgb2gray(img);

% Detect edges
edges = edge(img_gray,'canny');
imshow(edges)

% Hough Transform
[H, theta, rho] = hough(edges);
peaks = houghpeaks(H, 12);
lines = houghlines(edges, theta, rho, peaks,'FillGap',1000);


% Plot lines
imshow(img_gray), hold on;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',4,'Color','green');
   
   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
end