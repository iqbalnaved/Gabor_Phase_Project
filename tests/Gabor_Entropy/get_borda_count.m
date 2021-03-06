function borda = get_borda_count(gallery_im, probe_im, test_size, filters)


    lambda = [4 round(4*sqrt(2)) 8 round(8*sqrt(2)) 16]; 

    % subsample
    gallery_im1 = gallery_im(1:lambda(1):end, 1:lambda(1):end);
    gallery_im2 = gallery_im(1:lambda(2):end, 1:lambda(2):end);
    gallery_im3 = gallery_im(1:lambda(3):end, 1:lambda(3):end);
    gallery_im4 = gallery_im(1:lambda(4):end, 1:lambda(4):end);
    gallery_im5 = gallery_im(1:lambda(5):end, 1:lambda(5):end);

    gEO_Mag1 = gcv_convolve(gallery_im1, 'mag', filters{1});
    gEO_Mag2 = gcv_convolve(gallery_im2, 'mag', filters{2});
    gEO_Mag3 = gcv_convolve(gallery_im3, 'mag', filters{3});
    gEO_Mag4 = gcv_convolve(gallery_im4, 'mag', filters{4});
    gEO_Mag5 = gcv_convolve(gallery_im5, 'mag', filters{5});

    % subsample
    probe_im1 = probe_im(1:lambda(1):end, 1:lambda(1):end);
    probe_im2 = probe_im(1:lambda(2):end, 1:lambda(2):end);
    probe_im3 = probe_im(1:lambda(3):end, 1:lambda(3):end);
    probe_im4 = probe_im(1:lambda(4):end, 1:lambda(4):end);
    probe_im5 = probe_im(1:lambda(5):end, 1:lambda(5):end);

    pEO_Mag1 = gcv_convolve(probe_im1, 'mag', filters{1});
    pEO_Mag2 = gcv_convolve(probe_im2, 'mag', filters{2});
    pEO_Mag3 = gcv_convolve(probe_im3, 'mag', filters{3});
    pEO_Mag4 = gcv_convolve(probe_im4, 'mag', filters{4});
    pEO_Mag5 = gcv_convolve(probe_im5, 'mag', filters{5});

    %cosine distance

    voter1 = cosine_similarity(gEO_Mag1, pEO_Mag1);
    voter2 = cosine_similarity(gEO_Mag2, pEO_Mag2);
    voter3 = cosine_similarity(gEO_Mag3, pEO_Mag3);
    voter4 = cosine_similarity(gEO_Mag4, pEO_Mag4);
    voter5 = cosine_similarity(gEO_Mag5, pEO_Mag5);

%     if test_size > 0      
%         load(['gcv_entropy_weights_' num2str(test_size)]);    
%         load('gcv_entropy_weights_20');    
%         borda = E(1) * voter1 + E(2) * voter2 + E(3) * voter3 + E(4) * voter4 + E(5) * voter5;
%     else
        borda = voter1 + voter2 + voter3 + voter4 + voter5;        
%     end
    
    
end

    