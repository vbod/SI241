function HPviz= disp_lines_in_Hough(Hbin_rot)
% Parameters to detect peaks
Nlines = 20;
threshold = 0.2;

% Rescale Hough Transform
Hbin_rot_viz = imresize(Hbin_rot,[size(Hbin_rot,2),size(Hbin_rot,2)]);
% figure('name','Hough Transform rescaled'); imshow(Hbin_rot_viz)

% Hough Transform of Hough Transform
[HP,thetaP,rhoP] = hough(Hbin_rot_viz,'RhoResolution',1,'Theta',-90:0.5:89.5);
HPviz = imresize(HP,[size(HP,2),size(HP,2)]); HPviz = 255*(HPviz - min(min(HPviz))*ones(size(HPviz)))/(max(max(HPviz))-min(min(HPviz)));
figure('name','HoughTransform of HoughTransform'); imshow(uint8(HPviz)), hold on

% Detect Peaks 
peaksP  = houghpeaks(HP, Nlines,'Threshold',threshold*max(HP(:))); 
peaksPviz = peaksP; peaksPviz(:,1) = floor(peaksP(:,1)*(size(HP,2)/size(HP,1)));
x = peaksPviz(:,2); y = peaksPviz(:,1);
plot(x,y,'s','color','white');

% Display lines in Hough Transform
lines = houghlines(Hbin_rot_viz, thetaP, rhoP, peaksP,'FillGap',1000);
disp_lines_in_img(Hbin_rot_viz,lines)