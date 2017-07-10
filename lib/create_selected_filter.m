function create_selected_filter(R, C)

filter = zeros(R,C, 8);

% filters having rank-1 in normalized, sorted, 40 filter accuracy list for 4 probe sets.
% orientation scale

% for top magnitude based filters
selected_filters = [0 3; 1 3; 2 3; 7 3; 0 4; 4 4; 5 4; 7 4];

x = 1;
for i = length(selected_filters)
    u = selected_filters(i,1);    
    v = selected_filters(i,2);
    filter(:,:,x) = GaborWavelet( R, C, u, v); % Create the Gabor filter
    x = x + 1;
end

save('filters\selected_filter', 'filter');