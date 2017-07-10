clear;clc;
addpath('E:\Face Recognition\Gabor_Project_v4\lib\');

nregion = 64; nbin = 256;

gabor_type = 'gcc';
method = 'mag';

sm_type = 'cosine'; % euclidean, cityblock, cosine, jaccard, mahal
probe_set = 'fc'; % fb, fc, dup1, dup2

load(['..\..\filters\' gabor_type '_filter']);

test_size = 100;
probe_size = 100;

gallery_path = ['E:\Face Recognition\Gabor_Project_v4\db\fa' probe_set '_' num2str(test_size) '\'];
probe_path = ['E:\Face Recognition\Gabor_Project_v4\db\' probe_set '_'  num2str(test_size) '\'];

gallery_file_list = dir(gallery_path);
probe_file_list = dir(probe_path);

SM = zeros(length(gallery_file_list)-2, length(probe_file_list)-2);

for i = 3:length(gallery_file_list)
    im = imread([gallery_path gallery_file_list(i).name]);    
    if strcmp(gabor_type, 'gcc') == 1
        gim1 = gcc_convolve(im, method, filter);
    elseif strcmp(gabor_type, 'gss') == 1
        gim1 = gss_convolve(im, method, filter);
    end
    
    tic
    for j = 3:length(probe_file_list)
        im = imread([probe_path probe_file_list(j).name]);    
        if strcmp(gabor_type, 'gcc') == 1
            gim2 = gcc_convolve(im, method, filter);
        elseif strcmp(gabor_type, 'gss') == 1
            gim2 = gss_convolve(im, method, filter);
        end
        
        SM(i-2,j-2) = distance_measure(gim1, gim2, sm_type);                
    end
    toc
    fprintf('processed probes against %d ', i-2);
end

if strcmp(sm_type, 'cosine') == 1 || strcmp(sm_type, 'jaccard') == 1 
    [max_sim max_gallery_index] = max(SM);
else
    [max_sim max_gallery_index] = min(SM);
end

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
fid = fopen(['..\..\results\' gabor_type '\' gabor_type '_' method '_' probe_set '_' sm_type '_' num2str(test_size) '.txt'], 'a');
fprintf(fid, '\r%d out of %d matched', match_count, probe_size);
fprintf(fid, '\rrecognition acc: %f%%', (match_count / probe_size) * 100);

save(['..\..\sim_matrix\' gabor_type '\' gabor_type '_' method '_' probe_set '_' sm_type '_' num2str(test_size) ], 'SM');

