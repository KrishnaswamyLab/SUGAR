function random_points = generate(data, npts, noise_cov)
%GENERATE Compute the number of new points to generate around each point in a
%       dataset     https://arxiv.org/abs/1802.04927
% Authors: Ofir Lindenbaum, Jay S. Stanley III.
%
% Usage:
%         npts = numpts(degree, varargin) Generate npts, the estimate of
%         the number of points generate according to degree.
%
%Input 
%       data
%       npts=number of points to generate
%       sigma_n= covariance for the Gaussian
%       
%Output
%       random_points= noisy generated points
%     







Rep_Centers=[];
Rep_Cov=[];
j=0;

if size(sigma_n)==1
    for i=1:size(data,1)
        new_center=repmat(data(i,:)',1,l_hat(i));
        Rep_Centers=[Rep_Centers,new_center];

    end
    random_points=mvnrnd(Rep_Centers',sigma_n*ones(1,size(data,2)) );
else
    for i=1:size(data,1) 
        new_center=repmat(data(i,:)',1,l_hat(i));
        j=j+l_hat(i);
        Rep_Centers=[Rep_Centers,new_center];
        if l_hat(i)~=0  
            Rep_Cov= cat(3, Rep_Cov, repmat(sigma_n{i},1,1,l_hat(i)));
        end     
    end
    random_points=mvnrnd(Rep_Centers',Rep_Cov);
end
end

