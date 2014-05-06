function peaks_rot_final = delete_artefacts(H_rot,peaks_rot, theta_rot)

% Delete artefact of peaks on -45 and 45
peaks_rot_final = [];
for i = 1:size(peaks_rot,1)
    art45 = (theta_rot(peaks_rot(i,2)) >= 44.9 &&  theta_rot(peaks_rot(i,2)) <= 45.1);
    artm45 = (theta_rot(peaks_rot(i,2)) >= -45.1 &&  theta_rot(peaks_rot(i,2)) <= -44.1);
    art90 = (theta_rot(peaks_rot(i,2)) >= 89.9 &&  theta_rot(peaks_rot(i,2)) <= 90.1);
    artm90 = (theta_rot(peaks_rot(i,2)) >= -90.1 &&  theta_rot(peaks_rot(i,2)) <= -89.9);
    art135 = (theta_rot(peaks_rot(i,2)) >= 134.9 &&  theta_rot(peaks_rot(i,2)) <= 135.1);
    artm135 = (theta_rot(peaks_rot(i,2)) >= -135.1 &&  theta_rot(peaks_rot(i,2)) <= -134.9);    
    if ~(art45 || art90 || art135 || artm45 || artm90 || artm135)
        peaks_rot_final = [peaks_rot_final;peaks_rot(i,:)];
    end
end



% Vizualization

% Hviz_rot = imresize(H_rot,[size(H_rot,2),size(H_rot,2)]);
Hviz_rot = H_rot;
Hviz_rot = 255*(Hviz_rot - min(min(Hviz_rot))*ones(size(Hviz_rot)))/(max(max(Hviz_rot))-min(min(Hviz_rot)));
figure('name','Rotated HoughTransform')
imshow(uint8(Hviz_rot)), hold on;

peaksviz_rot = peaks_rot_final;
% peaksviz_rot(:,1) = floor(peaks_rot(:,1)*(size(H,2)/size(H,1)));
x = peaksviz_rot(:,2); y = peaksviz_rot(:,1);
plot(x,y,'s','color','red');