function peaks_refined = Hough_refined_with_periodicity2(H_rot,linesH,peaks_grid)
% Parameters
threshold_Hough_zoom = 0.5;
width_zoom = 0.45; % length of square zoom is width_zoom*per_finale

peaks_refined = [];
for k =1:2
    peaks_grid{k} = circshift(peaks_grid{k},[0,1]);
    [~,I] = sort(peaks_grid{k}(:,2));
    peaks_grid{k} = peaks_grid{k}(I,:);
    
    line_dir = zeros(1,2);
    line_dir(1) = linesH(k).w(2); line_dir(2) = -linesH(k).w(1); line_dir = line_dir/norm(line_dir);
    if line_dir(2)<0
        line_dir = -line_dir;
    end
    
    per = [];
    for i = 1:size(peaks_grid{k},1)-1
        vec_peaks = peaks_grid{k}(i,:) - peaks_grid{k}(i+1,:);
        ecart = abs(vec_peaks * line_dir');
        per = [per,ecart];
    end
    per_final = ransac_per(per);

    peaks_seed = peaks_grid{k}(1,:);
    not_seed = 1;
    while not_seed
        peaks_try = max(round(peaks_seed - per_final*line_dir),1);
        if H_rot(peaks_try(2),peaks_try(1))  == 0
            not_seed = 0;
        else
            peaks_seed = peaks_try;
        end
    end
    
    figure
    not_end = 1;
    while not_end
        H_zoom = H_rot(round(peaks_seed(2)-per_final*width_zoom) : round(peaks_seed(2)+per_final*width_zoom),...
            round(peaks_seed(1)-per_final*width_zoom) : round(peaks_seed(1)+per_final*width_zoom));
        
        peaks = houghpeaks(H_zoom, 1,'Threshold',threshold_Hough_zoom*max(H_zoom(:)));
        if size(peaks,1) == 2
            peaks = peaks + repmat([round(peaks_seed(2)-per_final*width_zoom),round(peaks_seed(1)-per_final*width_zoom)],2,1);
        elseif size(peaks,1) == 1
            peaks = peaks + [round(peaks_seed(2)-per_final*width_zoom),round(peaks_seed(1)-per_final*width_zoom)];
        end
        peaks_refined = [peaks_refined; peaks];
        
        
        
        % Vizualizations
        Hviz_rot = zeros(size(H_rot));
        Hviz_rot(round(peaks_seed(2)-per_final*width_zoom) : round(peaks_seed(2)+per_final*width_zoom),...
            round(peaks_seed(1)-per_final*width_zoom) : round(peaks_seed(1)+per_final*width_zoom)) =...
            H_rot(round(peaks_seed(2)-per_final*width_zoom) : round(peaks_seed(2)+per_final*width_zoom),...
            round(peaks_seed(1)-per_final*width_zoom) : round(peaks_seed(1)+per_final*width_zoom));
        imshow(uint8(Hviz_rot)), hold on;
        
        peaksviz_rot = peaks;
        % peaksviz_rot(:,1) = floor(peaks_rot(:,1)*(size(H,2)/size(H,1)));
        x = peaksviz_rot(:,2); y = peaksviz_rot(:,1);
        plot(x,y,'s','color','red');
        pause(1)
        clf
        
        
        peaks_try = round(peaks_seed + per_final*line_dir);
        if H_rot(peaks_try(2),peaks_try(1))  == 0
            not_end = 0;
        else
            peaks_seed = peaks_try;
        end
    end
end


% Visualizations
Hviz_rot = H_rot;
% Hviz_rot = imresize(H_rot,[size(H_rot,2),size(H_rot,2)]);
Hviz_rot = 255*(Hviz_rot - min(min(Hviz_rot))*ones(size(Hviz_rot)))/(max(max(Hviz_rot))-min(min(Hviz_rot)));
figure('name','Rotated HoughTransform')
imshow(uint8(Hviz_rot)), hold on;

peaksviz_rot = peaks_refined;
% peaksviz_rot(:,1) = floor(peaks_rot(:,1)*(size(H,2)/size(H,1)));
x = peaksviz_rot(:,2); y = peaksviz_rot(:,1);
plot(x,y,'s','color','red');

end