function filter = create_gcc_filter(R, C)

nscale = 5; norient = 8;

filter = zeros(R,C, nscale*norient);

x = 1;
for v = 0:4
    for u = 0:7
        filter(:,:,x) = LogGaborWavelet( R, C, u, v); % Create the Gabor filter
        x = x + 1;
    end
end

% save('filters\gcc_filter', 'filter');