% This function takes local histograms of two images, number of regions
% partitioned and the similarity measure to be considered as inputs. If the
% similarity_measure is 'direct' it performs a histogram intersection of
% the the two given local histograms and returns the sum of the intersection
% of the histograms for all regions.
% If similarity_measure is 'euclidean'/'minkowski'/'chebyshev', it takes
% the sum of the distance measures for the n regios and returns it.
function S = weighted_matching(LH1, LH2, similarity_measure, W)

    if(length(size(LH1)) == 3) % size(LH1) or size(LH2) = 256x64x40/8/5
        if strcmp(similarity_measure, 'hi')
            hi = sum(sum(min(LH1,LH2))) .* W; % hi size 1x64
            S = sum(hi); 
        elseif strcmp(similarity_measure, 'euclidean')
            S = sum(sum(sum((LH1-LH2).^2)))^0.5; % 256x64-256x64, this is done for all 40/8/5 dim               
        elseif strcmp(similarity_measure, 'minkowski')
            S = sum(sum(sum(abs(LH1-LH2)))); % city block metric, p=1                
        elseif strcmp(similarity_measure, 'chebyshev')
            S = max(max(max(LH1-LH2)));                 
        else
            disp('Invalid similarity measure');
            return;
        end    
    else % size(LH1)= 256x64, size(LH2) = 256x64
        if strcmp(similarity_measure, 'hi')
            hi = sum(min(LH1,LH2)) .* W; % size of min(LH1,LH2) = 256x64, hi size 1x64
            S = sum(hi);                 % Size of S 1x1
        elseif strcmp(similarity_measure, 'euclidean')
            hi = sum((LH1-LH2).^2) .* W;
            S = sum(hi)^0.5;
        elseif strcmp(similarity_measure, 'minkowski')
            S = sum(sum(abs(LH1-LH2))); % city block metric, p=1
        elseif strcmp(similarity_measure, 'chebyshev')
            S = max(max(LH1-LH2)); 
        else
            disp('Invalid similarity measure');
            return;            
        end    
    end
end    
