function [score_final,peaks_in_line,w,b] = ransac_maison(peaks,res)
% Parameters
N = size(peaks,1);
K = max(floor(N*1/3),2); % take at least 2 points among 3 to build a line
Niter = 10; % Number of iterations to find a good model
switch res
    case 256
        d = 20;
    case 512
        d = 40;
    case 1024
        d = 80;
    case 2048
        d = 160;
end

if  N <=2
    score_final = N;
    peaks_in_line = peaks;
    if N == 2
        peaks = circshift(peaks,[0,1]);    % Reparemetrization of the peaks as points [x,y] in the Hough transform
        w = peaks(2,:) - peaks(1,:); 
        a = w(1); w(1) = -w(2); w(2) = a; w = w'; w = w/norm(w);
        b = peaks(1,:)*w; 
    else
        w = [1;0]; b = 0;
    end
else
    % Reparemetrization of the peaks as points [x,y] in the Hough transform
    peaks = circshift(peaks,[0,1]);
    
    score = zeros(Niter,1);
    w = zeros(2,Niter); b = zeros(Niter,1);
    for k = 1:Niter
        X = peaks(randperm(N,K),:);
        w(:,k) = (X'*X)\X'*ones(K,1);
        b(k) = 1/norm(w(:,k)); w(:,k) = w(:,k)/norm(w(:,k));
        
        inliers{k} = [];
        for i = 1:size(peaks,1)
            if abs(peaks(i,:)*w(:,k)-b(k)) <= d
                inliers{k} = [inliers{k};peaks(i,:)];
            end
        end
        
        if ~isempty(inliers{k})
            
            w(:,k) = (inliers{k}'*inliers{k})\inliers{k}'*ones(size(inliers{k},1),1);
            b(k) = 1/norm(w(:,k)); w(:,k) = w(:,k)/norm(w(:,k));
            
            inliers{k} = [];
            for i = 1:size(peaks,1)
                if abs(peaks(i,:)*w(:,k)-b(k)) <= d
                    inliers{k} = [inliers{k};peaks(i,:)];
                end
            end
        end
        
        score(k) = size(inliers{k},1);
    end
    
    [score_final,index] = max(score);
    peaks_in_line = inliers{index}; peaks_in_line = circshift(peaks_in_line,[0,1]);
    w = w(:,index); b = b(index);
    
end
end

