clear;clc;
addpath('E:\Face Recognition\Gabor_Project_v5\lib\');

nregion = 64; nbin = 256;

gabor_type = 'gmuv'; 
method = 'pha'; % mag, pha

% ProbeSets = {'fb', 'fc', 'dup1', 'dup2'};
ProbeSets = {'fb_csu'};
% ProbeSets = {'combined_probe'};

for p = 1:length(ProbeSets)
    probe_set = ProbeSets{p};  
    
    if strcmp(probe_set, 'dup2') || strcmp(probe_set, 'fadup2')
        test_size = 75;
        probe_size = 75;
    else
        test_size = 200;
        probe_size = 200;
    end    

    gallery_path = ['E:\Face Recognition\Gabor_Project_v4\db\fa' probe_set '_' num2str(test_size) '\'];
%     gallery_path = ['E:\Face Recognition\Gabor_Project_v4\db\combined_gallery_' num2str(test_size) '\'];
    probe_path = ['E:\Face Recognition\Gabor_Project_v4\db\' probe_set '_'  num2str(test_size) '\'];
    

    gallery_file_list = dir(gallery_path);
    probe_file_list = dir(probe_path);
    
    SimTypes  = {'hi', 'euclidean', 'cosine', 'cityblock', 'jaccard', 'mahal', 'hamming'};
    
% 
%     if strcmp(probe_set, 'fb') 
%         start = 2;
%     else
%         start = 1;
%     end        
%     for s = start:length(SimTypes)-4 %skipping last three
%     for s = 1:length(SimTypes)-4 %skipping last three
     for s = 1:1
        sm_type = SimTypes{s};  

        fid = fopen(['..\..\results\' gabor_type '\' gabor_type '_' method '_' probe_set '_' sm_type '_' num2str(test_size) '.txt'], 'a');
        fprintf(fid, '\r%s %s %s %s\r\r', gabor_type, method, probe_set, sm_type);
        
        for v = 0:4
            for u = 0:7

                load(['..\..\lh\' gabor_type '\' gabor_type '_' method '_fa' probe_set '_' num2str(test_size) '_v' num2str(v) '_u' num2str(u) ]);
%                 load(['..\..\lh\' gabor_type '\' gabor_type '_' method '_combined_gallery_' num2str(test_size) '_v' num2str(v) '_u' num2str(u) ]);
                LH_Gallery_list = LH_list; clear LH_list;
                load(['..\..\lh\' gabor_type '\' gabor_type '_' method '_' probe_set '_' num2str(test_size) '_v' num2str(v) '_u' num2str(u)]);
                LH_Probe_list = LH_list; clear LH_list;

                SM = zeros(size(LH_Gallery_list,3), size(LH_Probe_list,3));

                for i = 1:size(LH_Gallery_list,3)
                    tic
                    for j = 1:size(LH_Probe_list,3)
                        SM(i,j) = direct_matching(LH_Gallery_list(:,:,i), LH_Probe_list(:,:,j), sm_type);        
                    end
                    toc
                    fprintf('processed probes against %d ', i);
                end    

    %             load(['..\..\sim_matrix\' gabor_type '\' gabor_type '_' method '_' probe_set '_' sm_type '_' num2str(test_size) '_v' num2str(v) '_u' num2str(u)]);

                if strcmp(sm_type, 'hi') || strcmp(sm_type, 'cosine') || strcmp(sm_type, 'jaccard')
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
                fprintf('\r%s %s %s %s recognition acc: %f%%', gabor_type, method, probe_set, sm_type, (match_count / probe_size) * 100);

%                 fprintf(fid, '\r%d out of %d matched', match_count, probe_size);
                fprintf(fid, 'Orientation=%d,Scale=%d\t%f%%\r', u, v, (match_count / probe_size) * 100);

                save(['..\..\sim_matrix\' gabor_type '\' gabor_type '_' method '_' probe_set '_' sm_type '_' num2str(test_size) '_v' num2str(v) '_u' num2str(u)], 'SM');
            end
        end
        fclose(fid);                
    end
end

msgbox('finished');