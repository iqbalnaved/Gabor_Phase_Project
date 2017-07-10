function filter = create_gcv_filter(R, C, v)

norient = 8;

filter = zeros(R,C, norient);

x = 1;
for u = 0:7
    filter(:,:,x) = LogGaborWavelet( R, C, u, v); % Create the Gabor filter
    x = x + 1;
end

% save(['filters\gcv_filter_v' num2str(v)], 'filter');