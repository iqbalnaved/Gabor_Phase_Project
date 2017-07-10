% get entropy weight for the 5 gcv filters

clear;clc;

lambda = [4 round(4*sqrt(2)) 8 round(8*sqrt(2)) 16];

test_size = 194;

% gallery_path = ['E:\Face Recognition\Gabor_Phase_Project_v2\db\gallery' num2str(test_size) '\'];
% probe_path = ['E:\Face Recognition\Gabor_Phase_Project_v2\db\probes'  num2str(test_size)  '\'];

gallery_path = 'E:\Face Recognition\Gray_FERET_1996_Set\Gray_FERET_1996_Set_Normalized\fa_normalized\';
probe_path = 'E:\Face Recognition\Gray_FERET_1996_Set\Gray_FERET_1996_Set_Normalized\fc_normalized\';


gallery_filelist = dir(gallery_path);
probe_filelist = dir(probe_path);

S1 = zeros(1, length(gallery_filelist)-2);
S2 = zeros(1, length(gallery_filelist)-2);
S3 = zeros(1, length(gallery_filelist)-2);
S4 = zeros(1, length(gallery_filelist)-2);
S5 = zeros(1, length(gallery_filelist)-2);

fprintf('calculating S1-5');
for i = 3:length(gallery_filelist)
    gallery_im = imread([gallery_path gallery_filelist(i).name]);

    gallery_im1 = gallery_im(1:lambda(1):end, 1:lambda(1):end);
    gallery_im2 = gallery_im(1:lambda(2):end, 1:lambda(2):end);
    gallery_im3 = gallery_im(1:lambda(3):end, 1:lambda(3):end);
    gallery_im4 = gallery_im(1:lambda(4):end, 1:lambda(4):end);
    gallery_im5 = gallery_im(1:lambda(5):end, 1:lambda(5):end);
    
    [gEO_Mag1 gEO_Pha1] = gaborcv(gallery_im1, 1);
    [gEO_Mag2 gEO_Pha2] = gaborcv(gallery_im2, 2);
    [gEO_Mag3 gEO_Pha3] = gaborcv(gallery_im3, 3);
    [gEO_Mag4 gEO_Pha4] = gaborcv(gallery_im4, 4);
    [gEO_Mag5 gEO_Pha5] = gaborcv(gallery_im5, 5);

    for j = 3:length(probe_filelist)
        probe_im = imread([probe_path probe_filelist(j).name]);

        probe_im1 = probe_im(1:lambda(1):end, 1:lambda(1):end);
        probe_im2 = probe_im(1:lambda(2):end, 1:lambda(2):end);
        probe_im3 = probe_im(1:lambda(3):end, 1:lambda(3):end);
        probe_im4 = probe_im(1:lambda(4):end, 1:lambda(4):end);
        probe_im5 = probe_im(1:lambda(5):end, 1:lambda(5):end);
        
        [pEO_Mag1 pEO_Pha1] = gaborcv(probe_im1, 1);
        [pEO_Mag2 pEO_Pha2] = gaborcv(probe_im2, 2);
        [pEO_Mag3 pEO_Pha3] = gaborcv(probe_im3, 3);
        [pEO_Mag4 pEO_Pha4] = gaborcv(probe_im4, 4);
        [pEO_Mag5 pEO_Pha5] = gaborcv(probe_im5, 5);

        S1(i-2) = S1(i-2) + cosine_similarity(gEO_Mag1, pEO_Mag1);
        S2(i-2) = S2(i-2) + cosine_similarity(gEO_Mag2, pEO_Mag2);
        S3(i-2) = S3(i-2) + cosine_similarity(gEO_Mag3, pEO_Mag3);
        S4(i-2) = S4(i-2) + cosine_similarity(gEO_Mag4, pEO_Mag4);
        S5(i-2) = S5(i-2) + cosine_similarity(gEO_Mag5, pEO_Mag5);
        
    end      
end

fprintf('\rcalculating entropy weights');
E1 = 0; E2 = 0; E3 = 0; E4 = 0; E5 = 0; % entropy weights
for j = 3:length(probe_filelist)
    probe_im = imread([probe_path probe_filelist(j).name]);

    probe_im1 = probe_im(1:lambda(1):end, 1:lambda(1):end);
    probe_im2 = probe_im(1:lambda(2):end, 1:lambda(2):end);
    probe_im3 = probe_im(1:lambda(3):end, 1:lambda(3):end);
    probe_im4 = probe_im(1:lambda(4):end, 1:lambda(4):end);
    probe_im5 = probe_im(1:lambda(5):end, 1:lambda(5):end);

    [pEO_Mag1 pEO_Pha1] = gaborcv(probe_im1, 1);
    [pEO_Mag2 pEO_Pha2] = gaborcv(probe_im2, 2);
    [pEO_Mag3 pEO_Pha3] = gaborcv(probe_im3, 3);
    [pEO_Mag4 pEO_Pha4] = gaborcv(probe_im4, 4);
    [pEO_Mag5 pEO_Pha5] = gaborcv(probe_im5, 5);   
    
    for i = 3:length(gallery_filelist)
        gallery_im = imread([gallery_path gallery_filelist(i).name]);

        gallery_im1 = gallery_im(1:lambda(1):end, 1:lambda(1):end);
        gallery_im2 = gallery_im(1:lambda(2):end, 1:lambda(2):end);
        gallery_im3 = gallery_im(1:lambda(3):end, 1:lambda(3):end);
        gallery_im4 = gallery_im(1:lambda(4):end, 1:lambda(4):end);
        gallery_im5 = gallery_im(1:lambda(5):end, 1:lambda(5):end);

        [gEO_Mag1 gEO_Pha1] = gaborcv(gallery_im1, 1);
        [gEO_Mag2 gEO_Pha2] = gaborcv(gallery_im2, 2);
        [gEO_Mag3 gEO_Pha3] = gaborcv(gallery_im3, 3);
        [gEO_Mag4 gEO_Pha4] = gaborcv(gallery_im4, 4);
        [gEO_Mag5 gEO_Pha5] = gaborcv(gallery_im5, 5);

        O1 = cosine_similarity(gEO_Mag1, pEO_Mag1);
        O2 = cosine_similarity(gEO_Mag2, pEO_Mag2);
        O3 = cosine_similarity(gEO_Mag3, pEO_Mag3);
        O4 = cosine_similarity(gEO_Mag4, pEO_Mag4);
        O5 = cosine_similarity(gEO_Mag5, pEO_Mag5);
        
        P1 = O1 / S1(i-2);        
        P2 = O2 / S2(i-2);        
        P3 = O3 / S3(i-2);        
        P4 = O4 / S4(i-2);        
        P5 = O5 / S5(i-2);                
        
        E1 = E1 + P1 * log2(P1);
        E2 = E2 + P2 * log2(P2);
        E3 = E3 + P3 * log2(P3);
        E4 = E4 + P4 * log2(P4);
        E5 = E5 + P5 * log2(P5);
    end
end

E1 = -E1;
E2 = -E2;
E3 = -E3;
E4 = -E4;
E5 = -E5;

E = [E1 E2 E3 E4 E5];

save(['gcv_entropy_weights_' num2str(test_size)], 'E');

fprintf('\rsaved');

