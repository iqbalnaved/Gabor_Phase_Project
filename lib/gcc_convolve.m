function EO_Part = gcc_convolve(I, method, filter)

nscale = 5; norient = 8;

R = size(I,1);
C = size(I,2);

imfft = fft2(I);

imfft40 = repmat(imfft, [1, 1, nscale*norient]);

temp = imfft40 .* filter; % convolve

EO = ifft2(temp);

if strcmp(method, 'mag')
    EO_Part = abs(EO);
elseif strcmp(method, 'pha')
    EO_Part = angle(EO);
end

