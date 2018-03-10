function random_points = generate(data, npts, noise_cov)
%GENERATE Generate randomly sampled Gaussian points around each point in a dataset    https://arxiv.org/abs/1802.04927
% Authors: Ofir Lindenbaum, Jay S. Stanley III.
%
% Usage:
%         random_points = generate(data, npts, noise_cov) Generate npts(i)
%         points centered at data(i,:) according to noise_cov(i)
% 
% Input: 
%       data           
%               N x D Data matrix. N rows are measurements, D columns are features.
%                   Accepts: 
%                       numeric
%       npts
%               number of points to generate around each point in data
%                   Accepts:
%                       N x 1 vector (will round to integer)
%
%       noise_cov
%               Covariance to use for point-generating Gaussians
%                   Accepts:
%                       N x 1 cell of D x D covariance matrices
%                       Scalar
%       
% Output:
%       random_points
%               sum(npts) x D Noisy generated points
%     

% initialize centers and covs for mvnrnd
Rep_Centers=[];
Rep_Cov=[];
j=0; % what is j used for?

if size(noise_cov)==1 % constant cov, no need to replicate cov.
    for i=1:size(data,1)
        % replicate data(i) to make npts(i) centers for mvnrnd
        new_center=repmat(data(i,:)',1,npts(i));
        Rep_Centers=[Rep_Centers,new_center]; 
    end
    random_points=mvnrnd(Rep_Centers',noise_cov *ones(1,size(data,2)) ); % generate
else
    for i=1:size(data,1) 
        new_center=repmat(data(i,:)',1,npts(i)); % replicate centers npts(i) times
        j=j+npts(i); % what is this?
        Rep_Centers=[Rep_Centers,new_center];
        if npts(i)~=0  
            Rep_Cov= cat(3, Rep_Cov, repmat(noise_cov{i},1,1,npts(i))); % replicate the covariance matrices
        end     
    end
    random_points=mvnrnd(Rep_Centers',Rep_Cov); % generate
end
end

