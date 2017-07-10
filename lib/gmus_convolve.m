function EO_Part = gmus_convolve(I, method, filter)

imfft = fft2(I);

temp = imfft .* filter; % convolve

EO = ifft2(temp);

if strcmp(method, 'mag')
    EO_Part = abs(EO);
elseif strcmp(method, 'pha')
    EO_Part = angle(EO);
end

