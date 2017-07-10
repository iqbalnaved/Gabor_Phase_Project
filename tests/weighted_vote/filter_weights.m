% builds a 40x1 matrix for the 200 subject set containing the classification 
% accuracy of 40 different filter representations using HI similarity measure.

addpath('E:\Face Recognition\Gabor_Project_v4\lib\');

test_size = 200; % testing the variance of the weights with lower test subjects
weight_sid_range = '1-200';

method = 'mag'; % mag, pha
similarity_measure = 'hi';
% similarity_measure = 'euclidean';
% similarity_measure = 'minkowski'; %city block distance
% similarity_measure = 'chebychev';

respath = '..\..\results\gmuv\'; 


AM = zeros(40,1); % accuracy list
x = 1;
for i = 1:8
    for j = 1:5
        filename = ['gmuv_' method '_' similarity_measure '_orient_' num2str(i) '_scale_' num2str(j) '_10-200.txt'];
        fid=fopen([respath filename]);
        C = textscan(fid, '%d\t\t%f%%');      
        fclose(fid);      
        disp(C{2}(10));
        AM(x) = C{2}(10); % taking the accuracy of recognizing the first 100 subjects
        x = x + 1;
    end
end

% sum_accuracy = sum(AM);

% filter secquence: o=1, s=1,2,3,4,5, o=2,s=1,2,3,4,5 and so on..
weight = AM/test_size;

save(['probability_weight_matrix_' method '_' similarity_measure '_sid' weight_sid_range '.mat'], 'weight');
