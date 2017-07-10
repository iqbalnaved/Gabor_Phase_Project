% local matching, sum of all distance measures of individual regions.
function dist = hamming_distance(lgbp1, lgbp2)

    nregion = size(lgbp1, 2);

    rows = size(lgbp1, 1);            % image size 128x128    
    cols = size(lgbp1, 2);            
    rsize = ( rows * cols ) / nregion;   % number of pixels per region (128*128)/64=256
    factors = factor(rsize);             % returns all the prime factors of rsize in an array
    rrows = prod(factors(1:floor(length(factors)/2))); % number of rows in a region, taking the product of half the factors = 16
    rcols = rsize/rrows;                % number of columns in a region, taking the rest of the factors, 256/16=16
    rgnPerRow = cols/rcols;             % number of regions in a row in the partitioned image 128/16=8
    
    dist = 0;
    
    if length(size(lgbp1)) == 3
        for k = 1:size(lgbp1,3)
            % the LGBP image is spatially partitioned into 64 nonoverlapping
            % regions of size 16x16
            x = 1; y = 1;        
            for r = 1:nregion
                z1 = lgbp1(x:x+rrows-1,y:y+rcols-1, k);
                z2 = lgbp2(x:x+rrows-1,y:y+rcols-1, k);
                z1 = reshape(z1, 1, size(z1,1)*size(z1,2));
                z2 = reshape(z2, 1, size(z2,1)*size(z2,2));
                C = bitxor(z1, z2); % 1 for each 1,0 or 0,1 pair
                dist = dist + sum(sum(dec2bin(C)-'0')); % count the number of 1s
                y = y + rcols;
                if(mod(r, rgnPerRow)==0) 
                    x = x + rrows;        
                    y = 1;
                end                   
            end
        end
    else
        % the LGBP image is spatially partitioned into 64 nonoverlapping
        % regions of size 16x16
        x = 1; y = 1;        
        for r = 1:nregion
            z1 = lgbp1(x:x+rrows-1,y:y+rcols-1);
            z2 = lgbp2(x:x+rrows-1,y:y+rcols-1);
            z1 = reshape(z1, 1, size(z1,1)*size(z1,2));
            z2 = reshape(z2, 1, size(z2,1)*size(z2,2));
            C = bitxor(z1, z2); % 1 for each 1,0 or 0,1 pair
            dist = dist + sum(sum(dec2bin(C)-'0')); % count the number of 1s
            y = y + rcols;
            if(mod(r, rgnPerRow)==0) 
                x = x + rrows;        
                y = 1;
            end                   
        end        
    end        
end


% holistic distance measure, considering whole image as a vector
% function dist = hamming_distance(lgbp1, lgbp2)
% 
%     if length(size(lgbp1)) == 3
%         lgbp1 = reshape(lgbp1, 1, size(lgbp1, 1)*size(lgbp1, 2)*size(lgbp1,3));
%         lgbp2 = reshape(lgbp2, 1, size(lgbp2, 1)*size(lgbp2, 2)*size(lgbp2,3));
%     else
%         lgbp1 = reshape(lgbp1, 1, size(lgbp1, 1)*size(lgbp1, 2));
%         lgbp2 = reshape(lgbp2, 1, size(lgbp2, 1)*size(lgbp2, 2));        
%     end
%     
%    C = bitxor(lgbp1, lgbp2); % 1 for each 1,0 or 0,1 pair
%    
%    dist = sum(sum(dec2bin(C)-'0')); % count the number of 1s
% 
% end