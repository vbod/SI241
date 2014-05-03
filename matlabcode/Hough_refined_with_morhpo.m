function edges = Hough_refined_with_morhpo(img_gray,peaks_grid,theta_rot)
% Parameters
length = 50;

angle = mean(theta_rot(peaks_grid{1}(:,2)));

se = strel('line',length,angle);

morph_grad = imdilate(img_gray,se) - imerode(img_gray,se);

figure
imshow(morph_grad)

edges = edge(morph_grad,'canny');
figure('name','contours')
imshow(edges)

end