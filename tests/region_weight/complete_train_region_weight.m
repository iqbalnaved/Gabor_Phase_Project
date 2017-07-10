clear;clc;
addpath('E:\Face Recognition\Gabor_Project_v5\lib');
gabor_type = 'gss'; % gcc, gsc, gcs, gss
method = 'mag'; % mag, pha

% training_path = 'E:\Face Recognition\Gray_FERET_1996_Set\Gray_FERET_1996_Set_FaceExtracted\training_set\';
training_path = 'E:\Face Recognition\Gabor_Project_v4\db\training_100\';
filelist = dir(training_path);

region = 64; bin = 256;

train_size = length(filelist)-2;
class = [];
samples_LH = {};

if strcmp(gabor_type, 'gcc')
    filter = create_gcc_filter(128,128);
elseif strcmp(gabor_type, 'gss')
    filter = create_gss_filter(128,128);
end

fprintf('processing traning samples\r');        

prev_subject_id = '';
i=3; 
x=1;
while i <= length(filelist)
    subject_id = filelist(i).name(1,1:5);
    if(strcmp(subject_id, prev_subject_id) == 0) % In same class, i.e. same subject
        j = 1;
        while(i <=length(filelist) && strcmp(subject_id,filelist(i).name(1,1:5)))
            im = imread([training_path filelist(i).name]);
            if strcmp(gabor_type, 'gcc')
                gim = gcc_convolve(im, method, filter);
            elseif strcmp(gabor_type, 'gss')
                gim = gss_convolve(im, method, filter);
            end
            lgbp = efficientLGBP(gim);              
            samples_LH{x,j} = efficientLH(lgbp, region, bin);                
            j = j + 1;
            i = i + 1;
        end
        class(x) = j-1; %sample count per class
        fprintf('class %d sample %d\r', x, class(x));
        x = x + 1;
    end
    prev_subject_id = subject_id;
end

save([ '..\..\region_weight\' gabor_type '\'  gabor_type '_' method '_region_weight_' num2str(train_size) '_samples_LH'], 'samples_LH');

fprintf('\rcalculating intrapersonal mean...\r');
mI = zeros(1, region);
for r = 1:region         
    T = 0;
    for i = 1:length(class) 
        S = 0;
        if class(i) > 1 % make sure each class has more than 1 samples
            for k = 2:class(i)
                for j = 1:k-1              
                    S = S + sum(min(samples_LH{i,j}(:,r), samples_LH{i,k}(:,r)));
                end
            end
        else
            continue;
        end
        T = T + ( 2 / ( class(i) * (class(i)-1) ) ) * S;
%         display(['i=' num2str(i) ',T=' num2str(T) ',S=' num2str(S)]);
    end 
    mI(r) = ( 1 / length(class) ) * T;
end

fprintf('calculating intrapersonal variance...\r');
SI = zeros(1,region);
for r = 1:region            
    for i = 1:length(class) 
        if class(i) > 1
            for k = 2:class(i)
                for j = 1:k-1                                                  
                    SI(r) = SI(r) + (sum(min(samples_LH{i,j}(:,r),samples_LH{i,k}(:,r))) - mI(r))^2;
                end
            end
        else
            continue;
        end
    end         
end

fprintf('calculating interpersonal mean...\r');
mE=zeros(1, region);
for r = 1:region        
    T = 0;
    for i = 1:length(class)-1 
        for j = i+1:length(class)
            S = 0;
            for k = 1:class(i)
                for l = 1:class(j)
                    S = S + sum(min(samples_LH{i,k}(:,r), samples_LH{j,l}(:,r)));
                end
            end
            T = T + ( 1 / ( class(i) * class(j) ) ) * S;
        end
    end         
    mE(r) = ( 2 / ( length(class) * (length(class)-1) ) ) * T;
end

fprintf('calculating interpersonal variance...\r');
SE = zeros(1, region);
for r = 1:region            
    for i = 1:length(class)-1            
        for j = i+1:length(class)
            for k = 1:class(i)
                for l = 1:class(j)
                    SE(r) = SE(r) + (sum(min(samples_LH{i,k}(:,r), samples_LH{j,l}(:,r))) - mE(r))^2;
                end
            end
        end
    end         
end

fprintf('calculating weight...\r');

%weight of the (v,mu,r)th region in the LGBP_Pha or LGBP_Pha image
W = zeros(1, region);

for r = 1:region            
    W(r) = (mI(r) - mE(r))^2 / (SI(r) + SE(r));
end

save([ '..\..\region_weight\' gabor_type '\'  gabor_type '_' method '_region_weight_' num2str(train_size)], 'W');


wmat = zeros(8);
r = 1;
for i = 1:8
    for j = 1:8
        wmat(i,j) = W(r);
        r = r + 1;
    end
end

wmat = wmat/max(max(wmat));

% imshow(wmat,[], 'InitialMagnification', 'fit');

imwrite(wmat, [ '..\..\region_weight\'  gabor_type  '\'  gabor_type '_' method '_region_weight_' num2str(train_size) '.jpg']);

