% Orient = {1,..,8} summed, Scale={0,..,4} concatenated
function filter = create_gsc_filter(R, C)

nscale = 5; norient = 8;

filter = zeros(R,C, nscale);

x = 1;
for v = 0:4
    for u = 0:7
        filter(:,:,x) = filter(:,:,x) + LogGaborWavelet( R, C, u, v ); % Create the Gabor filter
    end
    x = x + 1;    
end

filter = filter ./ norient;

% save('filters\gsc_filter', 'filter');