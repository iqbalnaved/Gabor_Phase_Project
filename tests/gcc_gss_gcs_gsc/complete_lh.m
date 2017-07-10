clear; clc;
addpath('E:\Face Recognition\Gabor_Project_v5\lib\');

R = 128; C = 128;
nscale = 5; norient = 8;
nregion = 64; nbin = 256;

gabor_type = 'gsc'; % gcc, gss, gcs, gsc
method = 'pha'; % mag, pha


% DBtypes = { 'fb', 'fc', 'dup1','dup2', 'fafb', 'fafc', 'fadup1', 'fadup2'};
% DBtypes = { 'fb', 'fafb'};
DBtypes = { 'fb_csu', 'fafb_csu'};
% DBtypes = { 'gallery_combined', 'probe_combined'};
% DBtypes = { 'gallery_indian', 'probe_indian'};
% DBtypes = { 'gallery_orl', 'probe_orl'};

if strcmp(gabor_type, 'gcc')
    filter = create_gcc_filter(R, C);        
elseif strcmp(gabor_type, 'gss') 
    filter = create_gss_filter(R, C);
elseif strcmp(gabor_type, 'gcs') 
    filter = create_gcs_filter(R, C);        
elseif strcmp(gabor_type, 'gsc') 
    filter = create_gsc_filter(R, C);        
end

for t = 1:length(DBtypes)
    db_type = DBtypes{t};
    
    if strcmp(db_type, 'dup2') || strcmp(db_type, 'fadup2')
        test_size = 75; % dup2,fadup2=75, all other=100
    else
        test_size = 200; % dup2,fadup2=75, all other=100    
    end

    path = ['E:\Face Recognition\Gabor_Project_v4\db\' db_type '_' num2str(test_size) '\'];

    files = dir(path);

%     load(['..\..\filters\' gabor_type '_filter']);

    if strcmp(gabor_type, 'gcc')
        LH_list = zeros(nbin, nregion, nscale*norient, length(files)-2, 'uint8');
    elseif strcmp(gabor_type, 'gss') 
        LH_list = zeros(nbin, nregion, length(files)-2, 'uint8');
    elseif strcmp(gabor_type, 'gcs') 
        LH_list = zeros(nbin, nregion, norient, length(files)-2, 'uint8');    
    elseif strcmp(gabor_type, 'gsc') 
        LH_list = zeros(nbin, nregion, nscale, length(files)-2, 'uint8');       
    end

    for i = 3:length(files)
        im = imread([path files(i).name]);
        if strcmp(gabor_type, 'gcc')    
            gim = gcc_convolve(im, method, filter);
            lgbp = efficientLGBP(gim);        
            LH_list(:,:,:,i-2) = efficientLH(lgbp, nregion, nbin);
        elseif strcmp(gabor_type, 'gss') 
            gim = gss_convolve(im, method, filter);
            lgbp = efficientLGBP(gim);                
            LH_list(:,:,i-2) = efficientLH(lgbp, nregion, nbin);
        elseif strcmp(gabor_type, 'gcs') 
            gim = gcs_convolve(im, method, filter);
            lgbp = efficientLGBP(gim);                
            LH_list(:,:,:,i-2) = efficientLH(lgbp, nregion, nbin);        
        elseif strcmp(gabor_type, 'gsc') 
            gim = gsc_convolve(im, method, filter);
            lgbp = efficientLGBP(gim);                
            LH_list(:,:,:,i-2) = efficientLH(lgbp, nregion, nbin);                
        end
    end

    save(['..\..\lh\' gabor_type '\' gabor_type '_' method '_' db_type '_' num2str(test_size) ], 'LH_list');
end    
msgbox('finished');