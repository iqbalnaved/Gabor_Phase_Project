% Here, similarity_measure is 'euclidean distance' and 'cityblock distance' and 'cosine similarityi', it
% finds the distance(or, similarity) measures between corresponding pixels of the two gabor images 
% then returns the sum of the distances(or, similarity).

function dist = distance_measure(GaborImg1, GaborImg2, dist_type)

    if length(size(GaborImg1)) == 3 % size(GaborImg) = 128x128x40/8/5        
        GaborImg1 = reshape(GaborImg1, 1, size(GaborImg1,1)*size(GaborImg1,2)*size(GaborImg1,3));
        GaborImg2 = reshape(GaborImg2, 1, size(GaborImg2,1)*size(GaborImg2,2)*size(GaborImg2,3));
    else
        GaborImg1 = reshape(GaborImg1, 1, size(GaborImg1,1)*size(GaborImg1,2));
        GaborImg2 = reshape(GaborImg2, 1, size(GaborImg2,1)*size(GaborImg2,2));
    end
        
    if strcmp(dist_type, 'euclidean') == 1 % euclidean distance
        dist = sqrt(sum((GaborImg1-GaborImg2).^2));
    elseif strcmp(dist_type, 'cityblock') == 1 % mahanttan or city block distance
        dist = sum(abs(GaborImg1-GaborImg2)); 
    elseif strcmp(dist_type, 'cosine') == 1 % cosine similarity
        numer = sum(GaborImg1 .* GaborImg2);     
        denom = sqrt(sum(GaborImg1.^2)) + sqrt(sum(GaborImg2.^2)); 
        dist = numer / denom;                        
    elseif strcmp(dist_type, 'jaccard') == 1 % jaccard similarity
        dist = numel(intersect(GaborImg1, GaborImg2)) / numel(union(GaborImg1,GaborImg2));
    elseif strcmp(dist_type, 'mahal') == 1 % mahalanobis distance
        dist = sum(mahal(GaborImg1',GaborImg2'));
    end

end