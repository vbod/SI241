function per_final = ransac_per(per)
% Parameters
N = length(per);
K = max(floor(N/4),1); % take at least 1 per
Niter = 50; % Number of iterations to find a good model
for i = 1:length(per)-1
    ecart(i) = abs(per(i)-per(i+1));
end
d = 2*min(ecart(i)); % maximal distance to detect periode


score = zeros(Niter,1);
per_mean = zeros(Niter,1);
for k = 1:Niter
    per_group = per(randperm(N,K));
    per_mean(k) = mean(per_group);
    
    inliers{k} = [];
    for i = 1:length(per)
        if abs(per_mean(k)-per(i)) < d
            inliers{k} = [inliers{k};per(i)];
        end
    end
    
    per_mean(k) = mean(inliers{k});
    inliers{k} = [];
    for i = 1:length(per)
        if abs(per_mean(k)-per(i)) < d
            inliers{k} = [inliers{k};per(i)];
        end
    end
    
    score(k) = length(inliers{k});
    
end

[~,index] = max(score);
per_final = per_mean(index);

end