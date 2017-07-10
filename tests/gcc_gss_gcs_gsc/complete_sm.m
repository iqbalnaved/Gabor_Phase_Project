clear;clc;
addpath('E:\Face Recognition\Gabor_Project_v5\lib\');

nregion = 64; nbin = 256;

gabor_type = 'gsc'; % gcc, gcs, gsc, gss
method = 'pha'; %mag, pha

% ProbeSets = {'fb', 'fc', 'dup1', 'dup2'};
% ProbeSets = {'fb'};
ProbeSets = {'fb_csu'};
% ProbeSets = {'combined'};
% ProbeSets = {'indian'};
% ProbeSets = {'orl'};

for p = 1:length(ProbeSets)
    probe_set = ProbeSets{p};  

    if strcmp(probe_set, 'dup2') || strcmp(probe_set, 'fadup2')
        test_size = 75;
        probe_size = 75;
    else
        test_size = 200;
        probe_size = 200;
    end    
    
%     SimTypes  = {'hi', 'euclidean', 'cityblock', 'cosine', 'jaccard', 'mahal', 'hamming'};
    SimTypes  = {'hi'};

    for s = 1:length(SimTypes)

        sm_type = SimTypes{s};  

        load(['..\..\lh\' gabor_type '\' gabor_type '_' method '_fa' probe_set '_' num2str(test_size)]);
%         load(['..\..\lh\' gabor_type '\' gabor_type '_' method '_gallery_' probe_set '_' num2str(test_size)]);        
        LH_Gallery_list = LH_list; clear LH_list;

        load(['..\..\lh\' gabor_type '\' gabor_type '_' method '_' probe_set '_' num2str(test_size)]);
%         load(['..\..\lh\' gabor_type '\' gabor_type '_' method '_probe_' probe_set '_' num2str(test_size)]);
        LH_Probe_list = LH_list; clear LH_list;

        if strcmp(gabor_type, 'gcc') || strcmp(gabor_type, 'gcs') || strcmp(gabor_type, 'gsc')
            SM = zeros(size(LH_Gallery_list,4), size(LH_Probe_list,4));

            for i = 1:size(LH_Gallery_list,4)
                tic
                for j = 1:size(LH_Probe_list,4)
                    SM(i,j) = direct_matching(LH_Gallery_list(:,:,:,i), LH_Probe_list(:,:,:,j), sm_type);        
                end
                toc
                fprintf('processed probes against %d ', i);
            end
        elseif strcmp(gabor_type, 'gss')
            SM = zeros(size(LH_Gallery_list,3), size(LH_Probe_list,3));

            for i = 1:size(LH_Gallery_list,3)
                tic
                for j = 1:size(LH_Probe_list,3)
                    SM(i,j) = direct_matching(LH_Gallery_list(:,:,i), LH_Probe_list(:,:,j), sm_type);        
                end
                toc
                fprintf('processed probes against %d ', i);
            end    
        end

        if strcmp(sm_type, 'hi') || strcmp(sm_type, 'cosine') || strcmp(sm_type, 'jaccard')
            [max_sim max_gallery_index] = max(SM);
        else
            [max_sim max_gallery_index] = min(SM);
        end

        gallery_path = ['E:\Face Recognition\Gabor_Project_v4\db\fa' probe_set '_' num2str(test_size) '\'];
%         gallery_path = ['E:\Face Recognition\Gabor_Project_v4\db\gallery_' probe_set '_' num2str(test_size) '\'];

        probe_path = ['E:\Face Recognition\Gabor_Project_v4\db\' probe_set '_'  num2str(test_size) '\'];
%         probe_path = ['E:\Face Recognition\Gabor_Project_v4\db\probe_' probe_set '_'  num2str(test_size) '\'];
        
        gallery_file_list = dir(gallery_path);
        probe_file_list = dir(probe_path);

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

        fid = fopen(['..\..\results\' gabor_type '\' gabor_type '_' method '_' probe_set '_' sm_type '_' num2str(test_size) '.txt'], 'a');
        fprintf(fid, '\r%d out of %d matched', match_count, probe_size);
        fprintf(fid, '\r%s %s %s %s recognition acc: %f%%', gabor_type, method, probe_set, sm_type,(match_count / probe_size) * 100);
% 
%         save(['..\..\sim_matrix\' gabor_type '\' gabor_type '_' method '_' probe_set '_' sm_type '_' num2str(test_size) ], 'SM');

    end
end