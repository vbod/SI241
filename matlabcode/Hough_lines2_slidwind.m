function [peaks_grid,linesH] = Hough_lines2_slidwind(H_rot,peaks_rot,theta_rot,res)
% Parameters
band = 30;
dep = min(theta_rot)+ band/2;

i = 1;
while dep +90 <= max(theta_rot)
    paquet1 = peaks_rot((theta_rot(peaks_rot(:,2)) >= dep - band/2) & (theta_rot(peaks_rot(:,2)) <= dep + band/2),:);
    [score1,peaks_in_line1{i},w1{i},b1{i}] = ransac_maison(paquet1,res);
%     score1_bis = size(paquet1,1);
    
    paquet2 = peaks_rot((theta_rot(peaks_rot(:,2)) >= dep + 90 - band/2) & (theta_rot(peaks_rot(:,2)) <= dep + 90 + band/2 ), :);
    [score2,peaks_in_line2{i},w2{i},b2{i}] = ransac_maison(paquet2,res);
%     score2_bis = size(paquet2,1);
%     dep
%     [score1_bis,score2_bis;score1,score2]
    if abs([1 0]*w1{i}) <= sqrt(2)/2 || abs([1 0]*w2{i}) <= sqrt(2)/2
        score(i) = 0;
    else
        score(i) = score1 + score2;
    end
    %     score(i) = score1 + score2;
    
    dep = dep + band/32; i = i+1;
end
% score
[~,index] = max(score);
peaks_grid{1} = peaks_in_line1{index}; peaks_grid{2} = peaks_in_line2{index};
linesH(1).w = w1{index}; linesH(2).w = w2{index};
linesH(1).b = b1{index}; linesH(2).b = b2{index};

% Vizualization
Hviz_rot = H_rot;
% Hviz_rot = imresize(H_rot,[size(H_rot,2),size(H_rot,2)]);
Hviz_rot = 255*(Hviz_rot - min(min(Hviz_rot))*ones(size(Hviz_rot)))/(max(max(Hviz_rot))-min(min(Hviz_rot)));
figure('name', 'Lines in Hough Transform');
imshow(uint8(Hviz_rot)), hold on;

peaksviz_rot = peaks_rot;
% peaksviz_rot(:,1) = floor(peaks_rot(:,1)*(size(H,2)/size(H,1)));
x = peaksviz_rot(:,2); y = peaksviz_rot(:,1);
plot(x,y,'s','color','red'), hold on;

for i = 1:2
    x = peaks_grid{i}(:,2); y = peaks_grid{i}(:,1);
    plot(x,y,'s','color','blue'), hold on;

end

[x,y] = meshgrid(1:size(Hviz_rot,2),1:size(Hviz_rot,1));
for i = 1:2
    f = linesH(i).w(1)*x + linesH(i).w(2)*y - linesH(i).b;
    contour(x,y,f,[0 0],'g'),hold on;
end
figure
