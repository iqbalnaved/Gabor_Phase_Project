function EO_Part = gss_convolve(I, method, gss_filter)

imfft = fft2(I);

temp = imfft .* gss_filter; % convolve

EO = ifft2(temp);

if strcmp(method, 'mag')
    EO_Part = abs(EO);
elseif strcmp(method, 'pha')
    EO_Part = angle(EO);
end

