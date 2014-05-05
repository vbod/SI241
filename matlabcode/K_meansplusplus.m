function [mu,labels,biggest_cluster] = K_meansplusplus (datas, K, nrounds)
%   Parameters
[d,T] = size(datas);

%   Initialisation
mu = zeros(d,K);
labels = zeros(1,T);

%   Initialization by choosing the first center at random and then 
%   the next centers among the datas according to a probability proportional 
%   to the distance to the nearest center
mu(:,1) =  datas(:,floor(T*rand)+1);
for k = 2:K
    distribution = zeros(1,T);
    for j = 1:T
        distance = zeros(1,k-1);
        for l = 1:k-1 
            distance(l) = norm(datas(:,j)-mu(:,l))^2;
        end
        distribution(j) = min(distance);
    end
    distribution = distribution/sum(distribution);
    mu(:,k) = datas(:,find(mnrnd(1,distribution)==1));
end

%   Assign each data to a center
for j = 1:T
    distance = zeros(1,K);
    for k = 1:K 
        distance(k) = norm(datas(:,j)-mu(:,k));
    end
    [~,labels(j)] = min(distance);
end

%   Compute the first distortion
distortion = 0;
for l = 1:T
    distortion = distortion + norm(mu(:,labels(l))-datas(:,l))^2;
end

t = 1;

while 1
    %   Adjust the centers
    for k = 1:K
        mu(:,k) = zeros(d,1);
        for j = 1:T
            mu(:,k) = mu(:,k) +(labels(j)==k)*datas(:,j);
        end
        mu(:,k) = mu(:,k)/sum(labels==k);
    end
    
    %   Assign each data to a center
    for j = 1:T
        distance = zeros(1,K);
        for k = 1:K 
            distance(k) = norm(datas(:,j)-mu(:,k));
        end
        [~,labels(j)] = min(distance);
    end
    
    %   Compute the distortion
    distortion_prec = distortion;
    distortion = 0;
    for l = 1:T
        distortion = distortion + norm(mu(:,labels(l))-datas(:,l))^2;
    end
    
    if (abs(distortion_prec-distortion)/distortion < 0.001) || (t == nrounds)
        disp(['Kmeans++ stopped at ',num2str(t),' iterations'])
        break;
    end
    t = t+1;
end

size_clusters = zeros(K,1);
for i = 1:K
    size_clusters(i) = sum(labels == i);
end

[~,biggest_cluster] = max(size_clusters);

% Vizualization
figure('name','Kmeans')
% colors =['r','b','g','y','k','m'];
% for i = 1:K
%    scatter3(datas(1,labels == i), datas(2,labels == i), datas(3,labels == i)),hold on;
% end
scatter3(datas(1,:), datas(2,:), datas(3,:)),hold on;
scatter3(datas(1,labels == biggest_cluster), datas(2,labels == biggest_cluster), datas(3,labels == biggest_cluster),'r')
biggest_cluster
end
