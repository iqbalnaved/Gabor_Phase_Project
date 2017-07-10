function EO_Part = selected_convolve(I, method, filter)

R = size(I,1);
C = size(I,2);

imfft = fft2(I);

imfft8 = repmat(imfft, [1, 1, 8]);

temp = imfft8 .* filter; % convolve

EO = ifft2(temp);

if strcmp(method, 'mag')
    EO_Part = abs(EO);
elseif strcmp(method, 'pha')
    EO_Part = angle(EO);
end

