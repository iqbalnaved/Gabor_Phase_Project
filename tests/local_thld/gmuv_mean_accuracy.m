% get mean accuracy for local threshold of each gallery image for 40
% filters.
load('gmuv_local_thld_test_60.mat');

res = zeros(5,8);

f = 1;
for v = 0:4
    for u = 0:7
        res(v+1,u+1) = mean(cell2mat(result(:,6,f)));
        f = f + 1;
    end
end

save('gmuv_mean_accuracy_test_60','res');
    
    