function filter = create_gmuc_filter(R, C, u)

nscale = 5; 

filter = zeros(R,C, nscale);

x = 1;
for v = 0:4
    filter(:,:,x) = LogGaborWavelet( R, C, u, v ); % Create the Gabor filter
    x = x + 1;
end

% save(['filters\gmuc_filter_u' num2str(u)], 'filter');