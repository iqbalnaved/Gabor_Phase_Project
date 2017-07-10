clear; clc;
addpath('E:\Face Recognition\Gabor_Project_v5\lib\');

nscale = 5; norient = 8;
nregion = 64; nbin = 256;
R = 128; C = 128;

gabor_type = 'gmuv'; 
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

    for v = 0:4
        for u = 0:7

%             load(['..\..\filters\' gabor_type '_filter_v' num2str(v) '_u' num2str(u)]);        
            filter = create_gmuv_filter(R, C, u, v);

            LH_list = zeros(nbin, nregion, length(files)-2, 'uint8');

            for i = 3:length(files)
                im = imread([path files(i).name]);
                gim = gmus_convolve(im, method, filter);
                lgbp = efficientLGBP(gim);                
                LH_list(:,:,i-2) = efficientLH(lgbp, nregion, nbin);                
            end

            save(['..\..\lh\' gabor_type '\' gabor_type '_' method '_' db_type '_' num2str(test_size) '_v' num2str(v) '_u' num2str(u)], 'LH_list');
        end
    end
end    
msgbox('finished');