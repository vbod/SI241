function peaks = Hough_refined(H,lines)

Hzoom = zoom_Hough(H,lines);

Hviz = imresize(Hzoom,[size(Hzoom,2),size(Hzoom,2)]);
figure('name','HoughRefined')
imshow(uint8(Hviz)), hold on;

peaks = houghpeaks(Hzoom, 100,'Threshold',0.01*max(Hzoom(:))); peaksviz = peaks;
peaksviz(:,1) = floor(peaks(:,1)*(size(H,2)/size(H,1)));
x = peaksviz(:,2); y = peaksviz(:,1);
plot(x,y,'s','color','red');