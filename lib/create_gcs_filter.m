function filter = create_gcs_filter(R, C)

nscale = 5; norient = 8;

filter = zeros(R,C, norient);

x = 1;
for u = 0:7
    for v = 0:4
        filter(:,:,x) = filter(:,:,x) + LogGaborWavelet( R, C, u, v); % Create the Gabor filter
    end
    x = x + 1;    
end

filter = filter ./ nscale;

% save('filters\gcs_filter', 'filter');