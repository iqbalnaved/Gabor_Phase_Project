clear; clc;
addpath('E:\Face Recognition\Gabor_Project_v4\lib\');

nscale = 5; norient = 8;
% nregion = [4 8 16 32 64 128 256 512 1024 2048 4096]; 
nregion = [4 8 16 32 64 128];

nbin = 256;

gabor_type = 'gcc'; % gcc, gss, gcs, gsc
method = 'pha'; % mag, pha


DBtypes = { 'fb', 'fafb', 'fc', 'dup1','dup2', 'fafc', 'fadup1', 'fadup2'}; 



for r = 1:length(nregion)
    for t = 1:length(DBtypes) 
        db_type = DBtypes{t};

        if strcmp(db_type, 'dup2') || strcmp(db_type, 'fadup2')
            test_size = 75; % dup2,fadup2=75, all other=100
        else
            test_size = 100; % dup2,fadup2=75, all other=100    
        end

        path = ['E:\Face Recognition\Gabor_Project_v4\db\' db_type '_' num2str(test_size) '\'];

        files = dir(path);

        load(['..\..\filters\' gabor_type '_filter']);

        if strcmp(gabor_type, 'gcc')
            LH_list = zeros(nbin, nregion(r), nscale*norient, length(files)-2, 'uint8');
        elseif strcmp(gabor_type, 'gss') 
            LH_list = zeros(nbin, nregion(r), length(files)-2, 'uint8');
        elseif strcmp(gabor_type, 'gcs') 
            LH_list = zeros(nbin, nregion(r), norient, length(files)-2, 'uint8');    
        elseif strcmp(gabor_type, 'gsc') 
            LH_list = zeros(nbin, nregion(r), nscale, length(files)-2, 'uint8');       
        end

        for i = 3:length(files)
            im = imread([path files(i).name]);
            if strcmp(gabor_type, 'gcc')    
                gim = gcc_convolve(im, method, filter);
                lgbp = efficientLGBP(gim);        
                LH_list(:,:,:,i-2) = efficientLH(lgbp, nregion(r), nbin);
            elseif strcmp(gabor_type, 'gss') 
                gim = gss_convolve(im, method, filter);
                lgbp = efficientLGBP(gim);                
                LH_list(:,:,i-2) = efficientLH(lgbp, nregion(r), nbin);
            elseif strcmp(gabor_type, 'gcs') 
                gim = gcs_convolve(im, method, filter);
                lgbp = efficientLGBP(gim);                
                LH_list(:,:,:,i-2) = efficientLH(lgbp, nregion(r), nbin);        
            elseif strcmp(gabor_type, 'gsc') 
                gim = gsc_convolve(im, method, filter);
                lgbp = efficientLGBP(gim);                
                LH_list(:,:,:,i-2) = efficientLH(lgbp, nregion(r), nbin);                
            end
        end

        save(['..\..\lh\region_test\' gabor_type '\' gabor_type '_' method '_' db_type '_' num2str(test_size) '_region_' num2str(nregion(r))], 'LH_list');
        fprintf('processed %s list for region %d\r', db_type, nregion(r));            
    end    
end
msgbox('finished');