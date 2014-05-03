function peaks = Hough_refined_with_zoom(H_rot,lines)
% Initializations
Hzoom = H_rot;

% Parameters
spread = 2;
Nlines = length(lines);

% Zoom on the lines in the Hough Transform
normaldir = zeros(Nlines,2);
for k = 1:Nlines
    dir = lines(k).point2 - lines(k).point1;
    normaldir(k,1) = dir(2); normaldir(k,2) = -dir(1);
    normaldir(k,:) = normaldir(k,:)/norm(normaldir(k,:));
end

for x = 1:size(H_rot,2)
    for y = 1:size(H_rot,1)
        val = zeros(Nlines,1);
        for k = 1:Nlines
            vec = [x,y] - lines(k).point1; 
            val(k) = abs(normaldir(k,:)*vec');
        end
        if min(val) > spread
            Hzoom(y,x) = 0;
        end
    end
end

% Detect peaks on these lines
peaks = houghpeaks(Hzoom, 100,'Threshold',0.1*max(Hzoom(:))); peaksviz = peaks;


% Visualization
Hviz = imresize(Hzoom,[size(Hzoom,2),size(Hzoom,2)]); Hviz = 255*(Hviz - min(min(Hviz))*ones(size(Hviz)))/(max(max(Hviz))-min(min(Hviz)));
figure('name','HoughRefined')
imshow(uint8(Hviz)), hold on;

peaksviz(:,1) = floor(peaks(:,1)*(size(H_rot,2)/size(H_rot,1)));
x = peaksviz(:,2); y = peaksviz(:,1);
plot(x,y,'s','color','red');