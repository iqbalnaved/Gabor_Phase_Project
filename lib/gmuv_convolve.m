function EO_Part = gmuv_convolve(I, method, gmuv_filter)

imfft = fft2(I);

temp = imfft .* gmuv_filter; % convolve


EO = ifft2(temp);

if strcmp(method, 'mag')
    EO_Part = abs(EO);
elseif strcmp(method, 'pha')
    EO_Part = angle(EO);
elseif strcmp(method, 'real')
    EO_Part = real(EO);
elseif strcmp(method, 'imag')
    EO_Part = imag(EO);
end


