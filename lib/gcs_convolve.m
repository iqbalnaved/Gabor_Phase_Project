function EO_Part = gcs_convolve(I, method, filter)

norient = 8;

imfft = fft2(I);

imfft8 = repmat(imfft, [1, 1, norient]);

temp = imfft8 .* filter; % convolve

EO = ifft2(temp);

if strcmp(method, 'mag')
    EO_Part = abs(EO);
elseif strcmp(method, 'pha')
    EO_Part = angle(EO);
end

