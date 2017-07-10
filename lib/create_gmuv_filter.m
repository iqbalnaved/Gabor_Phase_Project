function filter = create_gmuv_filter(R, C, u, v)

filter = LogGaborWavelet( R, C, u, v); % Create the Gabor filter

% save(['filters\gmuv_filter_v' num2str(v) '_u' num2str(u) ], 'filter');