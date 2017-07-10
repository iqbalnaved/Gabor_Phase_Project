clear; clc;
addpath('E:\Face Recognition\Gabor_Project_v5\lib\');

nscale = 5; norient = 8;
nregion = 64; nbin = 256;
R = 128; C = 128;
gabor_type = 'gcv'; % gcv, gsv, gmuc, gmus
method = 'pha'; % mag, pha


% DBtypes = { 'fb', 'fc', 'dup1','dup2', 'fafb', 'fafc', 'fadup1', 'fadup2'};
DBtypes = { 'fb_csu', 'fafb_csu'};
% DBtypes = { 'combined_gallery', 'combined_probe'};

for t = 1:length(DBtypes)
    db_type = DBtypes{t};
    
    if strcmp(db_type, 'dup2') || strcmp(db_type, 'fadup2')
        test_size = 75; % dup2,fadup2=75, all other=100
    else
        test_size = 200; % dup2,fadup2=75, all other=100    
    end

    path = ['E:\Face Recognition\Gabor_Project_v4\db\' db_type '_' num2str(test_size) '\'];

    files = dir(path);

    if strcmp(gabor_type, 'gcv') || strcmp(gabor_type, 'gsv')
        kval = 5;
        part_type = 'scale';
    elseif strcmp(gabor_type, 'gmuc') || strcmp(gabor_type, 'gmus')
        kval = 8;
        part_type = 'orient';
    end

    for k = 1:kval
        if strcmp(gabor_type, 'gcv')
            filter = create_gcv_filter(R,C,k-1);
        elseif strcmp(gabor_type, 'gsv')
            filter = create_gsv_filter(R,C,k-1);            
        elseif strcmp(gabor_type, 'gmuc')
            filter = create_gmuc_filter(R,C,k-1);
        elseif strcmp(gabor_type, 'gmus')
            filter = create_gmus_filter(R,C,k-1);            
        end

        if strcmp(gabor_type, 'gcv')
            LH_list = zeros(nbin, nregion, norient, length(files)-2, 'uint8');
        elseif strcmp(gabor_type, 'gmuc') 
            LH_list = zeros(nbin, nregion, nscale, length(files)-2, 'uint8');                   
        elseif strcmp(gabor_type, 'gsv') || strcmp(gabor_type, 'gmus') 
            LH_list = zeros(nbin, nregion, length(files)-2, 'uint8');
        end

        for i = 3:length(files)
            im = imread([path files(i).name]);
            if strcmp(gabor_type, 'gcv')       
                gim = gcv_convolve(im, method, filter);
                lgbp = efficientLGBP(gim);        
                LH_list(:,:,:,i-2) = efficientLH(lgbp, nregion, nbin);
            elseif strcmp(gabor_type, 'gmuc')       
                gim = gmuc_convolve(im, method, filter);
                lgbp = efficientLGBP(gim);        
                LH_list(:,:,:,i-2) = efficientLH(lgbp, nregion, nbin);                
            elseif strcmp(gabor_type, 'gsv')
                gim = gsv_convolve(im, method, filter);
                lgbp = efficientLGBP(gim);                
                LH_list(:,:,i-2) = efficientLH(lgbp, nregion, nbin);
            elseif strcmp(gabor_type, 'gmus') 
                gim = gmus_convolve(im, method, filter);
                lgbp = efficientLGBP(gim);                
                LH_list(:,:,i-2) = efficientLH(lgbp, nregion, nbin);                
            end
        end

        save(['..\..\lh\' gabor_type '\' gabor_type '_' method '_' db_type '_' num2str(test_size) '_' part_type '_' num2str(k-1)], 'LH_list');
    end
end    
msgbox('finished');