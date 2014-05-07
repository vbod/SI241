function [img_masked, mask] = mask_image(img_gray, edges, theta_rot, rho, peaks_grid)
% Parameters
width_line = 4;

lines = houghlines(edges, theta_rot, rho, peaks_grid,'FillGap',1000);

Nlines = length(lines);

% Zoom on the lines in the image
normaldir = zeros(Nlines,2);
for k = 1:Nlines
    dir = lines(k).point2 - lines(k).point1;
    normaldir(k,1) = dir(2); normaldir(k,2) = -dir(1);
    normaldir(k,:) = normaldir(k,:)/norm(normaldir(k,:));
end

img_masked  = img_gray;
%%%%%%%%% Modification Vincy %%%%%%%%%
mask = ones(size(img_gray));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for x = 1:size(img_gray,2)
    for y = 1:size(img_gray,1)
        val = zeros(Nlines,1);
        for k = 1:Nlines
            vec = [x,y] - lines(k).point1;
            val(k) = abs(normaldir(k,:)*vec');
        end
        if min(val) < width_line
            img_masked(y,x) = 0;
            %%%%%%%%% Modification Vincy %%%%%%%%%%
            mask(y,x) = 0;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
    end
end




end

