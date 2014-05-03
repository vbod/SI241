function Hough_refined_with rotation(img_gray,peaks_grid,theta_rot)
angle(1) = mean(theta_rot(peaks_grid{1}(:,2)));
% angle(2) = mean(theta_rot(peaksgrid{2}(:,2)));

img_gray_rot = imrotate(img_gray,angle(1));



% Vizeualization
figure('name','Image rotated along the grid')
imshow(img_gray_rot)


end

% h = fspecial('sobel')';
% grad_v = imfilter(img_gray_rot,h);
% [h,v] =size(grad_v);
% 
% threshold_grad = 0.7;
% grad_v = grad_v > threshold_grad*max(max(grad_v));
% 
% figure
% imshow(grad_v)
% 
