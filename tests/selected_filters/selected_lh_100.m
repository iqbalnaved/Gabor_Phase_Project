clear; clc;
addpath('E:\Face Recognition\Gabor_Project_v4\lib\');

nscale = 5; norient = 8;
nregion = 64; nbin = 256;

gabor_type = 'selected'; % gcc, gss, gcs, gsc
method = 'mag'; % mag, pha


DBtypes = { 'fb', 'fc', 'dup1','dup2', 'fafb', 'fafc', 'fadup1', 'fadup2'};

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

    LH_list = zeros(nbin, nregion, 8, length(files)-2, 'uint8');       

    for i = 3:length(files)
        im = imread([path files(i).name]);
        gim = selected_convolve(im, method, filter);
        lgbp = efficientLGBP(gim);        
        LH_list(:,:,:,i-2) = efficientLH(lgbp, nregion, nbin);
    end

    save(['..\..\lh\' gabor_type '\' gabor_type '_' method '_' db_type '_' num2str(test_size) ], 'LH_list');
end    
msgbox('finished');