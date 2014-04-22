function Hzoom = zoom_Hough(H,lines)
% Initializations
Hzoom = H;

% Parameters
spread = 1;
Nlines = length(lines);

ndir = zeros(Nlines,2);
for k = 1:Nlines
    dir = lines(k).point2 - lines(k).point1;
    ndir(k,1) = dir(2); ndir(k,2) = -dir(1);
    ndir(k,:) = ndir(k,:)/norm(ndir(k,:));
end

for x = 1:size(H,2)
    for y = 1:size(H,1)
        val = zeros(Nlines,1);
        for k = 1:Nlines
            vec = [x,y] - lines(k).point1; 
            val(k) = abs(ndir(k,:)*vec');
        end
        if min(val) > spread
            Hzoom(y,x) = 0;
        end
    end
end