function filter = create_gss_filter(R, C)

nscale = 5; norient = 8;

filter = zeros(R,C);

x = 1;
for v = 0:4
    for u = 0:7
        filter = filter + LogGaborWavelet( R, C, u, v ); % Create the Gabor filter
        x = x + 1;
    end
end

filter = filter ./ (nscale * norient);

% save('filters\gss_filter', 'filter');

% function filter = create_gss_filter(R, C, domain)
% 
% nscale = 5; norient = 8;
% 
% filter = zeros(R,C);
% 
% if strcmp(domain, 'spatial')
%     x = 1;
%     for v = 0:4
%         for u = 0:7
%             filter = filter + LogGaborWavelet( R, C, u, v ); % Create the Gabor filter
%             x = x + 1;
%         end
%     end
% else
%     x = 1;
%     for v = 0:4
%         for u = 0:7
%             f = LogGaborWavelet( R, C, u, v ); % Create the Gabor filter
%             filter = filter + fft2(f);
%             x = x + 1;
%         end
%     end    
% end
% 
% filter = filter ./ (nscale * norient);
% 
% end
% 
% 
