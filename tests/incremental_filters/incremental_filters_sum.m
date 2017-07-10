%% A simulation to find out efficacy of the reducing the filters from 
% "Orientation = {0,..,7} Scale={0,..,4} Summmed" Gabor filter magnitude response
% by incrementally adding highest weighted filter with the second
% second heighest and so on, and checking accuracy.
%%
clear;clc;
addpath('E:\Face Recognition\Gabor_Project_v5\lib\');
method = 'mag'; sim = 'hi'; weight_sid_range = '1-100';
% weight_matrix_mag_direct_sid1-100.mat
load(['E:\Face Recognition\Gabor_Phase_Project_v3\tests\weighted_vote\probability_weights_' method '_' sim '_sid' weight_sid_range '.mat']);

% Gabor magnitude filters sorted by filter weights, descending order
filter_by_w = [
4, 1; 5, 2; 1, 2; 2, 2; 3, 2;
4, 2; 5, 1; 6, 1; 8, 2; 2, 3;
1, 1; 1, 3; 3, 3; 7, 2; 7, 3;
8, 3; 2, 1; 3, 1; 8, 1; 6, 2; 
7, 1; 6, 3; 4, 3; 5, 3; 4, 4;
3, 4; 2, 4; 7, 4; 6, 4; 8, 4;
1, 4; 4, 5; 5, 4; 6, 5; 5, 5;
8, 5; 1, 5; 2, 5; 7, 5; 3, 5 ];

R = 128; C = 128;
nregion = 64; nbin = 256;

fid = fopen('incremental_gabor_sum_mag_200.txt', 'w');

% gallery_path = 'E:\Face Recognition\Gabor_Project_v4\db\fafb_200\';
% probe_path = 'E:\Face Recognition\Gabor_Project_v4\db\fb_200\';
gallery_path = 'E:\Face Recognition\CORF_Test\fafb10\';
probe_path = 'E:\Face Recognition\CORF_Test\fb10\';

gallery_files = dir(gallery_path);
probe_files = dir(probe_path);

sm = zeros(size(probe_files, 1)-2, size(gallery_files, 1)-2);

filter = zeros(R,C); filter_count = 0;
for i = 1:length(filter_by_w)
    o = filter_by_w(i, 1);
    s = filter_by_w(i, 2);
    filter = filter + create_gmuv_filter(R, C, o, s);   
    filter_count = filter_count + 1;
    for j = 3:length(probe_files)
        probe_image = imread([probe_path probe_files(j).name]);
        imfft = fft2(probe_image);
        temp = imfft .* filter; % convolve
        EO = ifft2(temp);
        EO_mag = abs(EO);
        lgbp_mag = efficientLGBP(EO_mag);
        lh_mag_probe = efficientLH(lgbp_mag, nregion, nbin);
        for k = 3:length(gallery_files)
            gallery_image = imread([gallery_path gallery_files(k).name]);
            imfft = fft2(gallery_image);
            temp = imfft .* filter; % convolve
            EO = ifft2(temp);
            EO_mag = abs(EO);
            lgbp_mag = efficientLGBP(EO_mag);
            lh_mag_gallery = efficientLH(lgbp_mag, nregion, nbin);
            
            sm(j-2,k-2) = direct_matching(lh_mag_probe, lh_mag_gallery, 'hi');
        end
        disp(['matched 200 gallery images with probe ' probe_files(j).name]);
    end
    
    [maxVal matchedIndex] = max(sm);
    
    match = 0;
    for m = 1:length(matchedIndex)
        gallery_id = gallery_files(m+2).name(1:5);
        probe_id =  probe_files(matchedIndex(m)+2).name(1:5);
        if strcmp(gallery_id, probe_id) == 1
            match = match + 1;
        end
    end
    display(['Number of filters summed: ' num2str(filter_count) ' Recognition accuracy: ' num2str((match/(size(probe_files,1)-2))*100) '%']);
    fprintf(fid, 'Number of filters summed: %d Recognition accuracy: %d\r', filter_count, (match/(size(probe_files,1)-2))*100);
end

fclose(fid);



