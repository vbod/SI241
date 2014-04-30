function pixel_labels = k_means_color(img, nb_clusters)
%K_MEANS_COLOR Summary of this function goes here
%   Detailed explanation goes here

% utilise LAB 
cform = makecform('srgb2lab');
img_he = applycform(img,cform);

ab = double(img_he(:,:,2:3));
nrows = size(ab, 1);
ncols = size(ab, 2);
ab = reshape(ab, nrows*ncols, 2);

% repeat the clustering 3 times to avoid local minima
[cluster_idx, cluster_center] = kmeans(ab, nb_clusters, 'Distance',...
                                       'sqEuclidean', 'Replicates', 10);

pixel_labels = reshape(cluster_idx, nrows, ncols);
imshow(pixel_labels,[]), title('image labeled by cluster index');

segmented_images = cell(1, nb_clusters);
rgb_label = repmat(pixel_labels, [1 1 3]);

for k = 1:nb_clusters
    color = img;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
end

plot = true;
if plot == true
    for k = 1:nb_clusters
        figure();
        imshow(segmented_images{k}), title(['objects in cluster ' num2str(k)]);
    end
end

end

