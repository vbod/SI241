clear all
close all

x = 0:2:20;
for i = 1:length(x)
     y(i) = x(i) + (rand(1,1)-0.5) +5;
end
X = [x;y]';
X = [X;20*rand(3,2)];

figure
scatter(X(:,1),X(:,2)),hold on;

% w = (X'*X)\X'*ones(size(X,1),1);
res = 0;
[score_final,peaks_in_line,w,b] = ransac_maison(X,res);
% abs(X*w-1)
[x,y] = meshgrid(0:0.1:20);
f = w(1)*x+w(2)*y-b;
contour(x,y,f,[0 0],'r')



% y = -10:10;
% x = 3*ones(size(y)) + (rand(size(y))-0.5*ones(size(y)));
% X = [x;y]';
% 
% figure
% scatter(x,y),hold on;
% 
% w = (X'*X)\X'*ones(length(x),1);
% [x,y] = meshgrid(-10:0.1:10);
% f = w(1)*x+w(2)*y-1;
% contour(x,y,f,[0 0],'r')
% axis([0 5 -10 10])% ezplot(w(1)*x+w(2)*y-1,[-10 10 -10 10])