addpath('E:\Face Recognition\Gabor_Project_v5\lib\');
clear;clc;
bin=256; region=64;

path = 'F:\Face Databases\CVC Face Database\facedetected_sets\train300\';
files = dir(path);

threshold = cell(60, 2, 40);
f = 1;
for v = 0:4
    for u = 0:7
        filter = create_gmuv_filter(128, 128, u, v);
        t=1;
        for i = 3:5:length(files)
            f1 = imread([path files(i).name]);
            f2 = imread([path files(i+1).name]);
            f3 = imread([path files(i+2).name]);
            f4 = imread([path files(i+3).name]);
            f5 = imread([path files(i+4).name]);

            gabor_pha_img1 = gmuv_convolve(f1, 'pha', filter);
            gabor_pha_img2 = gmuv_convolve(f2, 'pha', filter);
            gabor_pha_img3 = gmuv_convolve(f3, 'pha', filter);
            gabor_pha_img4 = gmuv_convolve(f4, 'pha', filter);
            gabor_pha_img5 = gmuv_convolve(f5, 'pha', filter);

            lgbp_pha1 = efficientLGBP(gabor_pha_img1);
            lgbp_pha2 = efficientLGBP(gabor_pha_img2);
            lgbp_pha3 = efficientLGBP(gabor_pha_img3);
            lgbp_pha4 = efficientLGBP(gabor_pha_img4);
            lgbp_pha5 = efficientLGBP(gabor_pha_img5);

            lh = zeros(bin,region,5);
            lh(:,:,1) = efficientLH(lgbp_pha1, region, bin);
            lh(:,:,2) = efficientLH(lgbp_pha2, region, bin);
            lh(:,:,3) = efficientLH(lgbp_pha3, region, bin);
            lh(:,:,4) = efficientLH(lgbp_pha4, region, bin);
            lh(:,:,5) = efficientLH(lgbp_pha5, region, bin);

            sm = zeros(10,1);
            x = 1;
            for j = 1:5
                for k = j+1:5
                    sm(x) = direct_matching(lh(:,:,j), lh(:,:,k), 'hi');
                    x = x + 1;
                end
            end        
            threshold{t,1,f} = files(i).name;    
            threshold{t,2,f} = min(sm);    
            t=t+1;
        end
        f = f + 1;
        fprintf('processed u=%d, v=%d\r', u, v);
    end
end

save('gmuv_individual_threshold_cvc_60', 'threshold');

msgbox('finished');