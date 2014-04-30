function [img,img_gray] = load_image(image,scale)
addpath('images')
img_big = imread(image);

img_gray_big = rgb2gray(img_big);
[h,v] = size(img_gray_big);
if h>v
    img_crop = img_big(1:v,:,:);
    img_gray_crop = img_gray_big(1:v,:,:);
else
    img_crop = img_big(:,1:h,:);
    img_gray_crop = img_gray_big(:,1:h,:);
end

img = zeros(scale,scale,3,'uint8');
for i = 1:3
    img(:,:,i)= imresize(img_crop(:,:,i),[scale,scale]);
end
img_gray = imresize(img_gray_crop,[scale,scale]);