%% similarity measure threshold based face recongition
% accuracy using 1000 subjects (P=500, N=500)
% We use a global similarity measure threshold to recognize face image.The recognition 
% system works as follows:
%%
    clear;clc;
    addpath('E:\Face Recognition\Gabor_Phase_Project_v3\lib');
    
%   method = 'pha'; 
    method = 'mag';
    
    fid = fopen(['global_threshold_gss_' method 'test_result.txt'], 'a'); %save result here

    gallery_path = 'E:\Face Recognition\Gabor_Phase_Project_v2\Threshold\global_sm_threshold\db\gallery500\';
    tp_probe_path = 'E:\Face Recognition\Gabor_Phase_Project_v2\Threshold\global_sm_threshold\db\probes500tp\';
    fp_probe_path = 'E:\Face Recognition\Gabor_Phase_Project_v2\Threshold\global_sm_threshold\db\probes500fp\';
    
    tp = 0; tn = 0; fp = 0; fn = 0;
    
    
    if strcmp(method, 'pha') == 1
        filter_sim_threshold = 10496; % calculated using gss_global_threshold.m
    elseif strcmp(method, 'mag') == 1
        filter_sim_threshold = 10368; % calculated using gss_global_threshold.m
    end
    
    fprintf('checking using positive samples\r');
    % test using positive samples
    pfiles = dir(tp_probe_path);      
    for k = 3:length(pfiles)
        Ip = imread([tp_probe_path pfiles(k).name]);
        id = pfiles(k).name(1:5);
        % LH_Pha_q contains the 40 cell arrays of local histograms of the
        % probe image
        LH_Pha_q = encoding(Ip, method);     
        
        f = dir([gallery_path id '*']);
        Ig = imread([gallery_path f.name]);
        LH_Pha_t = encoding(Ig, method);     
        
        sim_pha = direct_matching(LH_Pha_q, LH_Pha_t, 'hi'); 
        if sim_pha >= filter_sim_threshold
            s = 1;
        else
            s = 0;                
        end

    %         display(['s=' num2str(s)]);

        % find winner                
%         weight_threshold = 0.18;
%         if s >= weight_threshold
        if s > 0
            fprintf('%s %f true positive\r', id, s);
            fprintf(fid, '%s %f true positive\r', id, s);
            tp = tp + 1;
        else
            fn = fn + 1;
            fprintf('%s %f false negative\r', id, s);            
            fprintf(fid, '%s %f false negative\r', id, s);            
        end
    end
    
    fprintf('checking using negative samples\r');
    % test using negative samples
    pfiles = dir(fp_probe_path);      
    for k = 3:length(pfiles)
        Ip = imread([fp_probe_path pfiles(k).name]);
        id = pfiles(k).name(1:5);
        % LH_Pha_q contains the 40 cell arrays of local histograms of the
        % probe image
        LH_Pha_q = encoding(Ip, method);     
        
        f = dir([gallery_path id '*']);
        Ig = imread([gallery_path f.name]);
        LH_Pha_t = encoding(Ig, method);     
        

        sim_pha = direct_matching(LH_Pha_q, LH_Pha_t, 'hi'); 
        if sim_pha >= filter_sim_threshold
%                 SM(f) = weight(f);
            s = 1;
        else
            s = 0;                
        end

        % find winner                
        if s > 0
            fprintf('%s %f false positive\r', id, s);
            fprintf(fid, '%s %f false positive\r', id, s);
            fp = fp + 1;
        else
            tn = tn + 1;
            fprintf('%s %f true negative\r', id, s);            
            fprintf(fid, '%s %f true negative\r', id, s);            
        end
    end
    
    fprintf(fid, 'True positive: %d\r', tp);
    fprintf(fid, 'False positive: %d\r', fp);
    fprintf(fid, 'False Negative: %d\r', fn);
    fprintf(fid, 'True Negative: %d\r', tn);    
    fprintf(fid, '\raccuracy %f', (tp + tn) / 1000); % p +  n = 1000

    fprintf('True positive: %d\r', tp);
    fprintf('False positive: %d\r', fp);
    fprintf('False Negative: %d\r', fn);
    fprintf('True Negative: %d\r', tn);    
    fprintf('\raccuracy %f', (tp + tn) / 1000);
    
    fclose(fid);
    



         
