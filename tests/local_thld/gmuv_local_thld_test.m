addpath('E:\Face Recognition\Gabor_Project_v5\lib');
clear;clc;
region = 64;bin = 256;

probe_path = 'F:\Face Databases\CVC Face Database\facedetected_sets\probes60\';
gallery_path = 'F:\Face Databases\CVC Face Database\facedetected_sets\gallery60\';

pfiles = dir(probe_path);
gfiles = dir(gallery_path);

load('gmuv_individual_threshold_cvc_60.mat');

result = cell(60,6,40);
f = 1;
for v = 0:4
    for u = 0:7
        filter = create_gmuv_filter(128, 128, u, v);

        lh_gallery_list = zeros(256, 64, length(gfiles)-2);
        for i = 3:length(gfiles)
            gfname = gfiles(i).name; %take the first one of 5 images 
            gim = imread([gallery_path gfname]);
            gpi = gmuv_convolve(gim, 'pha', filter);
            lgbp_pha = efficientLGBP(gpi);
            lh_gallery_list(:,:,i-2) = efficientLH(lgbp_pha, region, bin);
        end

        lh_probe_list = zeros(256, 64, length(pfiles)-2);
        for i = 3:length(pfiles)
            pfname = pfiles(i).name;
            pim = imread([probe_path pfname]);    
            gpi = gmuv_convolve(pim, 'pha', filter);
            lgbp_pha = efficientLGBP(gpi);
            lh_probe_list(:,:,i-2) = efficientLH(lgbp_pha, region, bin);    
        end

%         fid = fopen(['gmuv_local_thld_u' num2str(u) '_v' num2str(v) 'test_60.txt'], 'w');

        for i = 1:size(lh_gallery_list,3)    
            tp=0; fn=0; fp=0; tn=0;    
            for j = 1:size(lh_probe_list,3)
                sm = direct_matching(lh_probe_list(:,:,j), lh_gallery_list(:,:,i), 'hi');

                if sm >= threshold{i,2,f}
                    if strcmp(pfiles(j+2).name(1:7),gfiles(i+2).name(1:7)) == 1
                        tp = tp + 1;
                    else
                        fp = fp + 1;
                    end
                else
                    if strcmp(pfiles(j+2).name(1:7),gfiles(i+2).name(1:7)) == 1            
                        fn = fn + 1;
                    else
                        tn = tn + 1;
                    end
                end
            end

            result{i,1,f} = gfiles(i+2).name;
            result{i,2,f} = tp;
            result{i,3,f} = fn;
            result{i,4,f} = fp;
            result{i,5,f} = tn;
            result{i,6,f} = (tp+tn)/60;

%             fprintf( 'gfname=%s\t', threshold{i,1});
%             fprintf( 'true positive =%f\r', tp);
%             fprintf( 'false negative =%f\r', fn);
%             fprintf( 'false positive =%f\r', fp);
%             fprintf( 'true negative =%f\r', tn);
%             fprintf( 'accuracy=%f\r', (tp+tn)/60);
        end
        f = f + 1;
%         fclose(fid);
        fprintf('processed u=%d v=%d\r', u, v);
    end
end

save('gmuv_local_thld_test_60', 'result');

msgbox('finished');