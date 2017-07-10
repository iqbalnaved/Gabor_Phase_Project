clear;clc;
test_size = 200; % to match sub ids 101-302 with index
max_sub_id = 302;
gabor_type = 'gmuv';

method = 'mag'; % 'pha', 'mag';
sm_type = 'hi'; % hi, euclidean, minkowski, chebyshev
% sm_type = 'euclidean';
% sm_type = 'minkowski';

gallery_path = ['..\..\..\Gabor_Phase_Project\db\gallery' num2str(test_size) '_sid101-302\']; %gallery path
gallery_file_list = dir(gallery_path);

% get the subject ids since there can be missing ids in between (for 1000 test
% set)
sub_id_list = zeros(1, size(gallery_file_list,1)-2);
x = 1;
for i = 3:size(gallery_file_list,1)
    sub_id_list(x) = str2double(gallery_file_list(i).name(1:5));
    x = x + 1;
end    

load(['weight_matrix_' method '_' sm_type '_sid1-100.mat']);

VoteMat = zeros(max_sub_id, max_sub_id, 40);

x = 1;
for o = 1:8
    for s = 1:5
        load(['..\..\sim_matrix\weighted_vote\' gabor_type '_' method '_' sm_type '_' num2str(test_size) '_orient_' num2str(o) '_scale_' num2str(s) 'sid101-302']);

        if strcmp(sm_type, 'hi') == 1
            % get which probe id got maximum similarity measure for each gallery id
            [max_sim matched_probe_id_list]= max(SM);
        else
            % replace all 0 values with intmax
            indx = find(SM==0);
            SM(indx) = intmax; 
            [max_sim matched_probe_id_list]= min(SM);
        end

        for i = 1:length(sub_id_list)
            % assign filer weight to the gallery id (in column) with the matched probe id 
            % (in row)
            VoteMat(matched_probe_id_list(1, sub_id_list(i)), sub_id_list(i), x) = weight(x);
        end
        x = x + 1;
        clear SM;
    end
end

save(['vote_matrix_' method '_' sm_type '_' num2str(test_size) '_sid101-302'], 'VoteMat');