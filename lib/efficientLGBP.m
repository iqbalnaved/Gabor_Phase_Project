% Method:
% apply [-1 0 0;0 1 0;0 0 0] filter. rotate the -1 value clockwise and sum
% all the convolution results.
function LGBP = efficientLGBP(GaborImg)
    % Better filtering/concolution based attitudes    
    iNeigh = [1 4 7 8 9 6 3 2]; % clockwise traverse the filter   
    filtCenter = 5;        
    
    if(length(size(GaborImg)) == 3) % for concatenated filters
        [rows cols height] = size(GaborImg);
        LGBP = zeros(size(GaborImg), 'uint8');
        for h = 1:height
            sumLBP = zeros(rows, cols, 'uint8');
            % initialize filter
            filt=zeros([3 3], 'double');
            filt(filtCenter) = 1;            
            filt(iNeigh(1)) = -1;            
            for i=1:length(iNeigh)
                % convolve 
                currNeighDiff = filter2(filt, GaborImg(:,:,h), 'same');

               % change sign since applying the 3x3 filter has the opposite result.
               % we need neighbor >= center = 1, and neighbor < center = 0       
               currNeighDiff = - currNeighDiff; 
               currNeighDiff(currNeighDiff >= 0) = 1;
               currNeighDiff(currNeighDiff < 0) = 0;

               % multiply by approp. power of 2, sum all the filter results
               sumLBP = sumLBP + 2^(i-1) * uint8(currNeighDiff);

               % rotate the -1 value in the filter in clockwise direction
               if i < length(iNeigh)
                  filt( iNeigh(i) ) = 0;
                  filt( iNeigh(i+1) ) = -1;
               end
            end

            LGBP(:,:,h) = sumLBP;
        end        
    else
        sumLBP = zeros(size(GaborImg), 'uint8');
        % initialize filter
        filt=zeros([3 3], 'double');        
        filt(filtCenter) = 1;                
        filt(iNeigh(1)) = -1;            
        for i=1:length(iNeigh)

            % convolve 
            currNeighDiff = filter2(filt, GaborImg, 'same');

           % change sign since applying the 3x3 filter has the opposite result.
           % we need neighbor >= center = 1, and neighbor < center = 0       
           currNeighDiff = - currNeighDiff; 
           currNeighDiff(currNeighDiff >= 0) = 1;
           currNeighDiff(currNeighDiff < 0) = 0;

           % multiply by approp. power of 2, sum all the filter results
           sumLBP=sumLBP + 2^(i-1) * uint8(currNeighDiff);

           % rotate the -1 value in the filter in clockwise direction
           if i<length(iNeigh)
              filt( iNeigh(i) )=0;
              filt( iNeigh(i+1) )=-1;
           end
        end

        LGBP = sumLBP;
    end
end
