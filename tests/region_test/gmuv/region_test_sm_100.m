clear;clc;
addpath('E:\Face Recognition\Gabor_Project_v4\lib\');

nregion = [4 8 16 32 64 128 256 512 1024 2048 4096]; 
nbin = 256;

gabor_type = 'gcc'; % gcc, gcs, gsc, gss
method = 'pha'; %mag, pha

ProbeSets = {'fb', 'fc', 'dup1', 'dup2'};



for p = 1:length(ProbeSets) % skipping fb set
    
    probe_set = ProbeSets{p};  

    if strcmp(probe_set, 'dup2') || strcmp(probe_set, 'fadup2')
        test_size = 75;
        probe_size = 75;
    else
        test_size = 100;
        probe_size = 100;
    end    

    %     SimTypes  = {'hi', 'euclidean', 'cityblock', 'cosine', 'jaccard', 'mahal', 'hamming'};
   sm_type = 'hi';  

%         for s = 1:length(SimTypes)-3 %skipping last three

    %         sm_type = SimTypes{s};  

      fid = fopen(['..\..\results\region_test\' gabor_type '\' gabor_type '_' method '_' probe_set '_' sm_type '_' num2str(test_size) '.txt'], 'a');    

      for r = 1:length(nregion)


            load(['..\..\lh\region_test\' gabor_type '\' gabor_type '_' method '_fa' probe_set '_' num2str(test_size) '_region_' num2str(nregion(r))]);
            LH_Gallery_list = LH_list; clear LH_list;
            load(['..\..\lh\region_test\' gabor_type '\' gabor_type '_' method '_' probe_set '_' num2str(test_size) '_region_' num2str(nregion(r))]);
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
            probe_path = ['E:\Face Recognition\Gabor_Project_v4\db\' probe_set '_'  num2str(test_size) '\'];

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

            fprintf(fid, '\r%d out of %d matched', match_count, probe_size);
            fprintf(fid, '\r%s %s %s %s region=%d recognition acc: %f%%\r\r', gabor_type, method, probe_set, sm_type, nregion(r), (match_count / probe_size) * 100);

            save(['..\..\sim_matrix\region_test\' gabor_type '\' gabor_type '_' method '_' probe_set '_' sm_type '_' num2str(test_size) '_region_' num2str(nregion(r))], 'SM');

      end
      fclose(fid);
%     end
end