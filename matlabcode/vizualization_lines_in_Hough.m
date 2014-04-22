function vizualization_lines_in_Hough(H,peaks)

Hbin = zeros(size(H)); mask = peaks(:,1) + size(H,1)*(peaks(:,2)-1); Hbin(mask) = 255;
Hbinviz = imresize(Hbin,[size(H,2),size(H,2)]);
figure; imshow(Hbinviz)

[HP,thetaP,rhoP] = hough(Hbinviz,'RhoResolution',1,'Theta',-90:0.5:89.5);
HPviz = imresize(HP,[size(HP,2),size(HP,2)]);
figure('name','HoughTransform'); imshow(HPviz), hold on

peaksP  = houghpeaks(HP, 2,'Threshold',0.5*max(HP(:))); 
peaksPviz = peaksP; peaksPviz(:,1) = floor(peaksP(:,1)*(size(HP,2)/size(HP,1)));
x = peaksPviz(:,2); y = peaksPviz(:,1);
plot(x,y,'s','color','white');

lines = houghlines(Hbinviz, thetaP, rhoP, peaksP,'FillGap',1000);

% Plot lines
figure('name','lines')
imshow(Hbinviz), hold on;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',4,'Color','green');
   
   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
end