function sim = cosine_similarity(M1, M2)
    % size(M1)  = 32x32x8 (subsampled by lambda)
    % size(M2)  = 32x32x8

%     sim = 0;
%     for i = 1:size(M1,1)
%         for j = 1:size(M1,2)
%             A = M1(i,j,:); % size(A) = 1x8
%             B = M2(i,j,:); % size(B) = 1x8
%             sim = sim + sum(A .* B) / ( sqrt(sum(A.^2)) + sqrt(sum(B.^2)) );
%         end
%     end

    numer = sum(M1 .* M2, 3);      %32x32
    denom = sqrt(sum(M1.^2, 3)) + sqrt(sum(M2.^2, 3)); %32x32

    sim = sum(sum(numer ./ denom));

end
