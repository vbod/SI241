function [H_rot,Hbin_rot,theta_rot,rho,peaks_rot,offset] = Hough_basic2(img_bin,res)
% Parameters corresponding to the resolution
switch res
    case 256
        Nlines_to_detect = 10;
        threshold_hough = 0.4;
        theta_prec = 0.2;
    case 512
        Nlines_to_detect = 40;
        threshold_hough = 0.5;
        theta_prec = 0.1;
    case 1024
        Nlines_to_detect = 80;
        threshold_hough = 0.5;
        theta_prec = 0.05;
    case 2048
        Nlines_to_detect = 160;
        threshold_hough = 0.5;
        theta_prec = 0.025;
end

% Classic Hough Transform
[H, theta, rho] = hough(img_bin,'RhoResolution',1,'Theta',-90:theta_prec:89.5);

peaks = houghpeaks(H, Nlines_to_detect,'Threshold',threshold_hough*max(H(:))); 

Hbin = zeros(size(H)); mask = peaks(:,1) + size(H,1)*(peaks(:,2)-1); Hbin(mask) = 255;

% Rotation to get the best window in theta
band = 10;
[~, offset] = window_opt(Hbin, band);

H_rot = circshift(H,[0,offset]);
mid = size(H_rot,1)/2;
for j = 1:offset
    for i = 1:size(H_rot,1)/2
        a = H_rot(i,j);
        H_rot(i,j) = H_rot(2*mid - i,j);
        H_rot(2*mid - i,j) = a;
    end
end

theta_rot = theta - (theta(offset)+90+theta_prec);

peaks_rot = houghpeaks(H_rot, Nlines_to_detect,'Threshold',threshold_hough*max(H(:))); 

Hbin_rot = zeros(size(H)); mask = peaks_rot(:,1) + size(H,1)*(peaks_rot(:,2)-1); Hbin_rot(mask) = 255;



% Vizualisation
Hviz = H;
% Hviz = imresize(H,[size(H,2),size(H,2)]); 
Hviz = 255*(Hviz - min(min(Hviz))*ones(size(Hviz)))/(max(max(Hviz))-min(min(Hviz)));
figure('name','HoughTransform')
imshow(uint8(Hviz)), hold on;

peaksviz = peaks;
% peaksviz(:,1) = floor(peaks(:,1)*(size(H,2)/size(H,1)));
x = peaksviz(:,2); y = peaksviz(:,1);
plot(x,y,'s','color','red');

Hviz_rot = H_rot;
% Hviz_rot = imresize(H_rot,[size(H_rot,2),size(H_rot,2)]);
Hviz_rot = 255*(Hviz_rot - min(min(Hviz_rot))*ones(size(Hviz_rot)))/(max(max(Hviz_rot))-min(min(Hviz_rot)));
figure('name','Rotated HoughTransform')
imshow(uint8(Hviz_rot)), hold on;

peaksviz_rot = peaks_rot;
% peaksviz_rot(:,1) = floor(peaks_rot(:,1)*(size(H,2)/size(H,1)));
x = peaksviz_rot(:,2); y = peaksviz_rot(:,1);
plot(x,y,'s','color','red');

% Hbinviz = imresize(Hbin,[size(H,2),size(H,2)]);
% figure('name','Maxima Hough'); imshow(Hbinviz)
% 
% Hbinviz_rot = circshift(Hbinviz,[0,offset]);
% figure('name', ['maxima hough, offset = ' num2str(offset)]);
% imshow(Hbinviz_rot);

