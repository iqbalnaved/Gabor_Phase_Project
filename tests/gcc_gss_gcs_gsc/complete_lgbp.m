clear; clc;
addpath('E:\Face Recognition\Gabor_Project_v4\lib\');

nscale = 5; norient = 8;
nregion = 64; nbin = 256;

R = 128;
C = 128;

gabor_type = 'gcc';
method = 'pha';
test_size = 100; % fadup2,dup2=75, all other=100

db_type = 'fafb'; % fb, fc, dup1, dup2, fafb, fafc, fadup1, fadup2


path = ['E:\Face Recognition\Gabor_Project_v4\db\' db_type '_' num2str(test_size) '\'];

files = dir(path);

load(['..\..\filters\' gabor_type '_filter']);

lgbp_list = zeros(R, C, nscale*norient, length(files)-2, 'uint8');

for i = 3:length(files)
    im = imread([path files(i).name]);
    gim = gcc_convolve(im, method, filter);    
    lgbp_list(:,:,:,i-2) = partitionedLGBP(gim);
end

save(['..\..\lgbp\' gabor_type '\' gabor_type '_' method '_lgbp_' db_type '_' num2str(test_size) ], 'lgbp_list');
    
