% This function takes local histograms of two images, number of regions
% partitioned and the similarity measure to be considered as inputs. If the
% similarity_measure is 'direct' it performs a histogram intersection of
% the the two given local histograms and returns the sum of the intersection
% of the histograms for all regions.

% histogram intersection:
% by taking the minimum of two bin frequencies, we are taking the common
% frequency of both values, e.g. if LH1(255) = 4, LH2(255) = 6, then
% min(LH1(255),LH2(255)) = 4, which is common to both LH1 and LH2.

function S = histogram_intersection(LH1, LH2)

    LH1 = double(LH1);
    LH2 = double(LH2);
    
    if(length(size(LH1)) == 3) % size(LH) = 256x64x40/8/5
        % 16834 is the maximum similarity measure we can get using the 64 local histograms of 
        % images size 128x128 using histogram intersection
        % now the similarity measure is a value in the range [0..1]            
        S = sum(sum(sum(min(LH1,LH2))))  / (16384 * size(LH1,3)); 
    else % size(LH) = 256x64
        % 16834 is the maximum similarity measure we can get using the 64 local histograms of 
        % images size 128x128 using histogram intersection
        % now the similarity measure is a value in the range [0..1]            
        S = sum(sum(min(LH1,LH2))) / 16384; 
    end
end    
