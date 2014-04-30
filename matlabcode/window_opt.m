function [img_rot, offset] = window_opt(img, band)
%ROTATION_OPT Summary of this function goes here
%   Detailed explanation goes here

energy = 1e10;
offset = 0;
img_rot = img;
p = floor(size(img,2)/(2*band));

for i = 1:ceil(size(img,2)/p)
    img = circshift(img, [0 p]);
    energy_new = norm(img(:,1:p),2) + norm(img(:,end-p:end),2);
    if energy_new < energy
       energy = energy_new;
       offset = p*i;
       img_rot = img;
    end
end
end

