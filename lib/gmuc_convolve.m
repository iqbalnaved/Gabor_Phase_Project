function EO_Part = gmuc_convolve(I, method, filter)

nscale = 5;

imfft = fft2(I);

imfft5 = repmat(imfft, [1, 1, nscale]);

temp = imfft5 .* filter; % convolve

EO = ifft2(temp);

if strcmp(method, 'mag')
    EO_Part = abs(EO);
elseif strcmp(method, 'pha')
    EO_Part = angle(EO);
end

