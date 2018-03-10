function [d_hat,s_hat,sigma] = degrees(data, varargin)
% DEGREES    compute degree and sparsity estimates of data   https://arxiv.org/abs/1802.04927
%   Authors: Ofir Lindenbaum, Jay S. Stanely III.
% 
% Usage:
%         d_hat = degrees(data, varargin) Estimate manifold degrees d_hat
%         [d_hat, s_hat] = degrees(data, varargin) Estimate sparsity s_hat = 1./d_hat 
%         [d_hat, s_hat, sigma] = degrees(data, varargin) Return estimated kernel bandwidth
%
% Input: 
%       data           
%               N x D Data matrix. N rows are measurements, D columns are features.
%                   Accepts: 
%                       numeric
%   varargin: 
%       kernel_sigma      (default = 'std')
%               Diffusion kernel bandwidth. 
%                   Accepts:    
%                        'std'- standard deviation of the distances
%                        'knn' - adaptive bandwidth,eg  kth neighbor distance
%                        'minmax'-  min-max on the distance matrix       
%                        'median'- the median of the distances      
%                         function handle - @(d) f(d) = scalar or N-length 
%                                   vector where d is an NxN distance matrix.    
%                         scalar - pre-computed bandwidth
%
%       k               (default = 5)
%               k-Nearest neighbor distance to use if kernel_sigma = 'knn'
%               Accepts:
%                       positive scalars
%
% Output:
%       d_hat
%               N x 1 vector of the degree at each point in data of size N
%       s_hat
%               N x 1 vector of the sparsity at each point, s_hat=1./d_hat
%       sigma
%               N x 1 (adaptive) or scalar (constant) estimated kernel bandwidth
%  

[data, kernel_sigma, k] = init(data,varargin{:});
%construct kernel
N=size(data,2);
D=pdist2(data, data);

if strcmp(kernel_sigma,'minmax')
    MinDv=min(D+eye(size(D))*10^15);
    eps_val=(max(MinDv));
    sigma=2*(eps_val)^2;
elseif strcmp(kernel_sigma,'median')
    sigma=median(median(D));
elseif strcmp(kernel_sigma, 'std')
    sigma=std(mean(D));
elseif strcmp(kernel_sigma, 'knn')
    knnDST = sort(D);
    sigma = knnDST(k+1,:);
elseif isscalar(kernel_sigma)
    sigma = kernel_sigma;
elseif isa(kernel_sigma, 'function_handle')
    sigma = kernel_sigma(D);
end

%Compute kernel elements
K=exp(-(D.^2./(2.*sigma.^2))); 
p = sum(K);

% Compute ouputs
d_hat=p*(N)/sum(p);

s_hat=1./d_hat;


end

function [data, kernel_sigma, k] = init(data, varargin)
    % helpers
    function tf = check_sigma(passed)
    % check that diffusion sigma is correct type
        valid_sigmas = {'std','knn', 'minmax', 'median'};
        if isscalar(passed) || isa(passed, 'function_handle') || ... %user supplied sigmas 
            any(cellfun(@(x) strcmp(passed,x), valid_sigmas))  % predefined sigma options
            tf = true;
        else
            tf = false;
        end
    end
    scalarPos = @(x) isscalar(x) && (x>0);

    % defaults
    default.kernel_sigma = 'std';
    default.k = 5;

    %parser configuration
    persistent p
    if isempty(p)
        p = inputParser;
        addRequired(p, 'data', @isnumeric);
        addParameter(p, 'kernel_sigma', default.kernel_sigma,@check_sigma);
        addParameter(p, 'k', default.k, scalarPos);
    end
    %parse
    parse(p, data, varargin{:})
    data = p.Results.data;
    kernel_sigma = p.Results.kernel_sigma;
    k = p.Results.k;
end

