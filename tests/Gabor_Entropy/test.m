cd 'E:\Face Recognition\Gabor_Project_v4\tests\Gabor_Entroy';
clear;clc;
addpath('E:\Face Recognition\Gabor_Project_v4\lib\');   

% s = [32 22 16 12 8];
% 
% for v = 0:4
%     create_gcv_filter(s(v+1),s(v+1),v);
% end

test_size = 10;   
probe_set = 'fc';

filters = cell(1,5);
for s = 1:5
    load(['..\..\filters\gcv_filter_v' num2str(s-1)]);
    filters{s} = filter; 
    clear filter;
end

% gallery_path = ['E:\Face Recognition\Gabor_Phase_Project_v2\db\gallery' num2str(test_size) '\'];
% probe_path = ['E:\Face Recognition\Gabor_Phase_Project_v2\db\probes' num2str(test_size) '\'];
    
% gallery_path = 'E:\Face Recognition\Gray_FERET_1996_Set\Gray_FERET_1996_Set_Normalized\fa_normalized\';
% probe_path = ['E:\Face Recognition\Gray_FERET_1996_Set\Gray_FERET_1996_Set_Normalized\' probe_set '_normalized\'];
    
gallery_path = 'E:\Face Recognition\Gabor_Phase_Project_v3\db\fafc_10\';
probe_path = 'E:\Face Recognition\Gabor_Phase_Project_v3\db\fc_10\';

gallery_filelist = dir(gallery_path);
probe_filelist = dir(probe_path);

SM = zeros(length(gallery_filelist)-2, length(probe_filelist)-2);

for i = 3:length(gallery_filelist)
    gallery_im = imread([gallery_path gallery_filelist(i).name]);
    for j = 3:length(probe_filelist)
        probe_im = imread([probe_path probe_filelist(j).name]);
%             SM(j-2,i-2) = get_borda_count(gallery_im, probe_im, 0);
        SM(i-2, j-2) = get_borda_count(gallery_im, probe_im, test_size, filters); 
    end
    disp(['processed probes against ' gallery_filelist(i).name]);
end

[max_bc matched_gallery_index] = max(SM);

match = 0;
for i = 1:length(matched_gallery_index)
    probe_id = probe_filelist(i+2).name(1:5);
    matched_gallery_id = gallery_filelist(matched_gallery_index(i)+2).name(1:5);
    if strcmp(matched_gallery_id, probe_id) == 1
        disp([probe_id ' matched with ' matched_gallery_id ' max_bc=' num2str(max_bc(i))]);                            
        match = match + 1;
    else
        disp([probe_id ' missmatch ' matched_gallery_id ' max_bc=' num2str(max_bc(i))]);                            
    end        
end

display(['match = ' num2str(match)]);

% save(['..\..\sim_matrix\gabor_entropy\similarity_matrix_fa' probe_set], 'SM');
        