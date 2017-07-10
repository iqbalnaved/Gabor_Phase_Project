clear; clc;
addpath('E:\Face Recognition\Gabor_Project_v5\lib\');

I = imread('E:\Face Recognition\Gabor_Project_v4\db\fafb_200\00002fa010_930831.pgm');

R = 128; C = 128;

domain = 'spatial'; %'spatial', 'freq' 

% 40 basic filters
for v = 0:4
    for u = 0:7
        filter = create_gmuv_filter(R, C, u, v);

        if strcmp(domain, 'spatial')
              re = angle(filter);
%             re = imag(filter);
        else
%             re = real(fft2(filter));
              re = imag(fft2(filter));
%             re = abs(fft2(filter));
%             re = angle(fft2(filter));
        end
        
        re = re / max(max(re));
        
        imwrite(re, ['gmuv\' domain '_domain_pha\gmuv_filter_v' num2str(v) '_u' num2str(u) '.tif'], 'tif');
        clear filter;
    end
end

% gss filter
% 
filter = create_gss_filter(R,C);

if strcmp(domain, 'spatial')
    re = real(filter);
else
    
%     re = abs(filter);    
    re = angle(filter);
end

re = re / max(max(re));

imwrite(re, ['gss\gss_filter_' domain '.tif'], 'tif');
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