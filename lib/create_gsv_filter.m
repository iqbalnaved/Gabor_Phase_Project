function filter = create_gsv_filter(R, C, v)

norient = 8;

filter = zeros(R,C);

for u = 0:7
    filter = filter + LogGaborWavelet( R, C, u, v ); % Create the Gabor filter
end

filter = filter ./ norient;

% save(['filters\gsv_filter_v' num2str(v)], 'filter');