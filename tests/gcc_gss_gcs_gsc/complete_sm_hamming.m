clear;clc;
addpath('E:\Face Recognition\Gabor_Project_v4\lib\');

nregion = 64; nbin = 256;

gabor_type = 'gcc';
method = 'mag';

sm_type = 'hamming'; 
probe_set = 'fb'; % fb, fc, dup1, dup2

load(['..\..\filters\' gabor_type '_filter']);

test_size = 100;
probe_size = 100;

gallery_path = ['E:\Face Recognition\Gabor_Project_v4\db\fa' probe_set '_' num2str(test_size) '\'];
probe_path = ['E:\Face Recognition\Gabor_Project_v4\db\' probe_set '_'  num2str(test_size) '\'];

gallery_file_list = dir(gallery_path);
probe_file_list = dir(probe_path);


load(['..\..\lgbp\' gabor_type '\' gabor_type '_' method '_lgbp_fa' probe_set '_' num2str(test_size)]);
Gallery_lgbp_list = lgbp_list; clear lgbp_list;
load(['..\..\lgbp\' gabor_type '\' gabor_type '_' method '_lgbp_' probe_set '_' num2str(test_size)]);
Probe_lgbp_list = lgbp_list; clear lgbp_list;

SM = zeros(size(Gallery_lgbp_list,4), size(Probe_lgbp_list,4));

for i = 1:size(Gallery_lgbp_list,4)
    lgbp1 = Gallery_lgbp_list(:,:,:,i);
    tic
    for j = 1:size(Probe_lgbp_list,4)
        lgbp2 = Probe_lgbp_list(:,:,:,j);    
        SM(i,j) = hamming_distance(lgbp1, lgbp2);                
    end
    toc
    fprintf('processed probes against %d ', i);
end

[max_sim max_gallery_index] = min(SM);


x = 1; match = {};
for i = 1:length(max_gallery_index)
    gallery_id = gallery_file_list(max_gallery_index(i)+2).name(1:5);
    probe_id = probe_file_list(i+2).name(1:5);
    if strcmp(gallery_id, probe_id) == 1
        match{x,1} = gallery_id;
        match{x,2} = probe_id;
        match{x,3} = max_sim(i);
        x = x + 1;
    end
end

if exist('match', 'var')
    match_count = size(match,1);
else
    match_count = 0;
end

fprintf('\r%d out of %d matched', match_count, probe_size);
fprintf('\rrecognition acc: %f%%', (match_count / probe_size) * 100);
fid = fopen(['..\..\results\' gabor_type '\' gabor_type '_' method '_' probe_set '_' sm_type '_' num2str(test_size) '_lgbp.txt'], 'a');
fprintf(fid, '\r%d out of %d matched', match_count, probe_size);
fprintf(fid, '\rrecognition acc: %f%%', (match_count / probe_size) * 100);

save(['..\..\sim_matrix\' gabor_type '\' gabor_type '_' method '_' probe_set '_' sm_type '_' num2str(test_size) '_lgbp'], 'SM');

