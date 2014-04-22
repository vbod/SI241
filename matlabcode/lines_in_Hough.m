function [linesH,finalpeaks] = lines_in_Hough(H,peaks)

Hbin = zeros(size(H)); mask = peaks(:,1) + size(H,1)*(peaks(:,2)-1); Hbin(mask) = 255;
Hbinviz = imresize(Hbin,[size(H,2),size(H,2)]);
figure; imshow(Hbinviz)

[HP,thetaP,rhoP] = hough(Hbin,'RhoResolution',1,'Theta',-90:0.5:89.5);
HPviz = imresize(HP,[size(HP,2),size(HP,2)]);
figure('name','HoughTransform of HoughTransform'); imshow(HPviz), hold on

peaksP  = houghpeaks(HP, 2, 'Threshold', 0.5*max(HP(:))); 
peaksPviz = peaksP; peaksPviz(:,1) = floor(peaksP(:,1)*(size(HP,2)/size(HP,1)));
x = peaksPviz(:,2); y = peaksPviz(:,1);
plot(x,y,'s','color','white');

linesH = houghlines(Hbin, thetaP, rhoP, peaksP,'FillGap',1000);

% Plot lines
figure('name','lines in HoughTransform')
imshow(Hbin), hold on;
for k = 1:length(linesH)
   xy = [linesH(k).point1; linesH(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',4,'Color','green');
   
   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
end

finalpeaks = [];
tolerance = 5;
line1 = linesH(1).point2 - linesH(1).point1; line1 = line1/norm(line1);
line2 = linesH(2).point2 - linesH(2).point1; line2 = line2/norm(line2);

peaks = circshift(peaks,[0,1]);
for i = 1:length(peaks)
    peaksline1 = peaks(i,:) - linesH(1).point1; peaksline1 = peaksline1/norm(peaksline1);
    peaksline2 = peaks(i,:) - linesH(2).point1; peaksline2 = peaksline2/norm(peaksline2);
    a = abs(peaksline1*line1'); a = acosd(a);
    b = abs(peaksline2*line2'); b = acosd(b);
    
    if (a<tolerance) || (b<tolerance)
        finalpeaks = [finalpeaks;peaks(i,:)];
    end
end

finalpeaks = circshift(finalpeaks,[0,1]);