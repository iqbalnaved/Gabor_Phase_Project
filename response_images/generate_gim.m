% generate gabor responses

I = imread('E:\Face Recognition\Gabor_Project_v4\db\fafb_200\00002fa010_930831.pgm');
R = 128; C = 128;
method = 'imag';

% 40 basic filters
for v = 0:4
    for u = 0:7
        filter = create_gmuv_filter(R,C,u,v);
%         gim = gmuv_convolve(I,method,filter);
        gim = double(I) .* filter;
        gim_nrm = imag(gim)/max(max(gim));
        
        imwrite(gim_nrm, ['gmuv\spatial_' method '\gmuv_gim_' method '_v' num2str(v) '_u' num2str(u) '.tif'], 'tif')
        clear filter;
    end
end

% gss filter
% load (['..\filters\gss_filter.mat']);
% 
% gim = gss_convolve(I,method,filter);
% gim_nrm = gim/max(max(gim));
% 
% imwrite(gim_nrm, ['gss\gss_gim_' method '.tif'], 'tif')
% clear filter;

% gsv filters
% for v = 0:4
%     load (['..\filters\gsv_filter_v' num2str(v) '.mat']);
% 
%     gim = gsv_convolve(I,method,filter);
%     gim_nrm = gim/max(max(gim));
% 
%     imwrite(gim_nrm, ['gsv\' method '\gsv_gim_' method '_v' num2str(v) '.tif'], 'tif')
%     clear filter;
% end

% gmus filters
% for u = 0:7
%     load (['..\filters\gmus_filter_u' num2str(u) '.mat']);
% 
%     gim = gmus_convolve(I,method,filter);
%     gim_nrm = gim/max(max(gim));
% 
%     imwrite(gim_nrm, ['gmus\' method '\gmus_gim_' method '_u' num2str(u) '.tif'], 'tif')
%     clear filter;
% end
msgbox('finished');