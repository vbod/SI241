function img = tophatallsegments(im)

for i = 1:16
    ang = i*180/16;
    se = strel(20,angle);
    