function g_kern = gauss_kernel(data1,data2, a, k,method,fac)

%Input: 
%   data1= first dataset
%   data2= second dataset 
%a = 2 for gaussian kernel
%a = 1 for laplacian kernel
%a > 2 for alpha decaying kernel
%   k= number of nearest neighbors for scaling the kernel
%   method
%    1= addaptive kernel
%    2= addaptive and truncted kernel
%    3= fixed scale kernel
%    fac= factor for rescaling the kernel's bandwidth
%   Output:
%   g_kern= mgc Gaussian kernel
pairwise_data = pdist2(data1,data2);

if method==1
    kNN_epsilon = k + 1;
    [~, knnDST] = knnsearch(data1,data2,'K',kNN_epsilon);
    epsilon = fac*knnDST(:,kNN_epsilon);
    epsilon(epsilon==0)=fac*min(epsilon(epsilon~=0));
elseif method==2
     kNN_epsilon = k + 1;
     [knnIDX, knnDST] = knnsearch(data1,data2,'K',kNN_epsilon);
     epsilon = fac*knnDST(:,kNN_epsilon);
     ptsIDX = repmat((1:size(knnIDX,1))',1,size(knnIDX,2));
     TruncFilter = true(size(ptsIDX,1),size(knnIDX,1)); % This is for truncation indexing
    % TruncFilter(sub2ind(size(TruncFilter),ptsIDX(:),knnIDX(:))) = false; % Don't truncate neighbors
else 
     MinDv=min(pairwise_data+eye(size(pairwise_data))*10^15);
     epsilon=fac*(max(MinDv));
end

clear knnDST
    pairwise_data = bsxfun(@rdivide, pairwise_data', epsilon)';
    g_kern = exp(-pairwise_data.^a);
    if method==2
    g_kern(TruncFilter&TruncFilter') = 0;
    %     g_kern=g_kern+g_kern';
end
 clear pairwise_data

end