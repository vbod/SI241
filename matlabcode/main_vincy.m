clear all
close all
% Parameters

% Load images
addpath('images')
img = imread('DSCN2368.jpg');
img_gray = rgb2gray(img);

% hamming_wind = hamming(size(img,1));
% hamming_wind = hamming_wind * hamming(size(img,2))';
% img_gray = uint8(im2double(img_gray).*hamming_wind);

% G = fspecial('gaussian',[20 20],200);
% Ig = imfilter(img,G,'same');
% figure('name','blurred');
% imshow(Ig)

% Detect edges
edges = edge(img_gray,'canny');
figure('name','contours')
imshow(edges)

% Hough Transform
[v,h] = size(img_gray);
[H, theta, rho] = hough(edges,'RhoResolution',1,'Theta',-90:0.5:89.5);
Hviz = imresize(H,[size(H,2),size(H,2)]);
figure('name','HoughTransform')
imshow(uint8(Hviz)), hold on;
% se = strel('diamond',5);
% filty = fspecial('sobel'); filtx = filty';
% grady = imfilter(uint8(Hviz),filty); gradx = imfilter(uint8(Hviz),filtx);
% grad = gradx.^2+grady.^2;
% figure,imshow(grad);
% figure
peaks = houghpeaks(H, 100,'Threshold',0.5*max(H(:))); peaksviz = peaks;
peaksviz(:,1) = floor(peaks(:,1)*(size(H,2)/size(H,1)));
x = peaksviz(:,2); y = peaksviz(:,1);
plot(x,y,'s','color','white');
lines = houghlines(edges, theta, rho, peaks,'FillGap',1000);

I = zeros(size(H)); mask = peaks(:,1) + size(H,1)*peaks(:,2); I(mask) = 255;
Iviz = imresize(I,[size(H,2),size(H,2)]);
figure();
imshow(Iviz);

% Plot lines
figure('name','lines')
imshow(img_gray), hold on;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',4,'Color','green');
   
   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
end