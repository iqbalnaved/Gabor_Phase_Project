clear;clc;
file = 'gmuv_pha_fb_csu_hi_200.txt';

fid = fopen(file);
C = textscan(fid, '%s\t%f%%', 'HeaderLines', 3); % skip first 3 lines
fclose(fid);