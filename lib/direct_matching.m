% This function takes local histograms of two images, number of regions
% partitioned and the similarity measure to be considered as inputs. If the
% similarity_measure is 'direct' it performs a histogram intersection of
% the the two given local histograms and returns the sum of the intersection
% of the histograms for all regions.
% If similarity_measure is 'euclidean'/'minkowski'/'chebyshev', it takes
% the sum of the distance measures for the n regios and returns it.

% histogram intersection:
% by taking the minimum of two bin frequencies, we are taking the common
% frequency of both values, e.g. if LH1(255) = 4, LH2(255) = 6, then
% min(LH1(255),LH2(255)) = 4, which is common to both LH1 and LH2.

function S = direct_matching(LH1, LH2, similarity_measure)

    nregion = 64;
    
    LH1 = double(LH1);
    LH2 = double(LH2);
    
    if(length(size(LH1)) == 3) % size(LH) = 256x64x40/8/5
        if strcmp(similarity_measure, 'hi')
            % 16834 is the maximum similarity measure we can get using the 64 local histograms of 
            % images size 128x128 using histogram intersection
            % now the similarity measure is a value in the range [0..1]            
            S = sum(sum(sum(min(LH1,LH2)))); 
        elseif strcmp(similarity_measure, 'euclidean')
            S = sum(sum(sum((LH1-LH2).^2)))^0.5; % 256x64-256x64, this is done for all 40/8/5 dim               
        elseif strcmp(similarity_measure, 'cityblock')
            S = sum(sum(sum(abs(LH1-LH2)))); % city block metric, p=1                
        elseif strcmp(similarity_measure, 'chebyshev')
            S = max(max(max(LH1-LH2)));                 
        elseif strcmp(similarity_measure, 'cosine') == 1 % cosine similarity
            numer = sum(LH1 .* LH2);     % size(numer) = 1x64x40/8/5
            denom = sqrt(sum(LH1.^2)) + sqrt(sum(LH2.^2)); % size(denom) = 1x64x40/8/5
            S = sum(sum(numer ./ denom));                        
        elseif strcmp(similarity_measure, 'jaccard') == 1 % jaccard similarity
            S = 0;
            for h = 1:size(LH1,3)
                for r = 1:nregion
                    S = S + numel(intersect(LH1(:,r, h), LH2(:,r, h))) / numel(union(LH1(:,r, h),LH2(:,r, h)));
                end
            end
        elseif strcmp(similarity_measure, 'mahal') == 1 % mahalanobis distance
            S = 0;
            for h = 1:size(LH1,3)
                for r = 1:nregion
                    S = S + sum(mahal(LH1(:, r, h),LH2(:, r, h)));
                end
            end            
        elseif strcmp(similarity_measure, 'hamming') == 1 % hamming distance
            S = 0;
            for h = 1:size(LH1,3)
                for r = 1:nregion                
                    C = bitxor(LH1(:,r,h), LH2(:,r,h)); % 1 for each 1,0 or 0,1 pair
                    S = S + sum(sum(dec2bin(C)-'0')); % count the number of 1s
                end            
            end
        else
            disp('Invalid similarity measure');
            return;
        end    
    else % size(LH) = 256x64
        if strcmp(similarity_measure, 'hi')
            % 16834 is the maximum similarity measure we can get using the 64 local histograms of 
            % images size 128x128 using histogram intersection
            % now the similarity measure is a value in the range [0..1]            
            S = sum(sum(min(LH1,LH2))); 
        elseif strcmp(similarity_measure, 'euclidean')
            S = sum(sum((LH1-LH2).^2))^0.5;
        elseif strcmp(similarity_measure, 'cityblock')
            S = sum(sum(abs(LH1-LH2))); % city block metric, p=1
        elseif strcmp(similarity_measure, 'chebyshev')
            S = max(max(LH1-LH2)); 
        elseif strcmp(similarity_measure, 'cosine') == 1 % cosine similarity
            numer = sum(LH1 .* LH2);     
            denom = sqrt(sum(LH1.^2)) + sqrt(sum(LH2.^2)); 
            S = sum(numer ./ denom);                        
        elseif strcmp(similarity_measure, 'jaccard') == 1 % jaccard similarity
            S = 0;
            for r = 1:nregion
                S = S + numel(intersect(LH1(:,r), LH2(:,r))) / numel(union(LH1(:,r),LH2(:,r)));
            end
        elseif strcmp(similarity_measure, 'mahal') == 1 % mahalanobis distance
            S = 0;
            for r = 1:nregion
                S = S + sum(mahal(LH1(:, r),LH2(:, r)));
            end
        elseif strcmp(similarity_measure, 'hamming') == 1 % hamming distance
            S = 0;
            for r = 1:nregion                
                C = bitxor(LH1(:,r), LH2(:,r)); % 1 for each 1,0 or 0,1 pair
                S = S + sum(sum(dec2bin(C)-'0')); % count the number of 1s
            end
        else
            disp('Invalid similarity measure');
            return;            
        end    
    end
end    
