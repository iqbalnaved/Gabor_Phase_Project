function filter = create_gmus_filter(R, C, u)

nscale = 5; 

filter = zeros(R,C);

for v = 0:4
    filter = filter + LogGaborWavelet( R, C, u, v); % Create the Gabor filter
end

filter = filter ./ nscale;

% save(['filters\gmus_filter_u' num2str(u)], 'filter');