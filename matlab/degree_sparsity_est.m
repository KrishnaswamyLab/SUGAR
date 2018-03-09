function [ d_hat,s_hat,sigma] = degree_sparsity_est(data,varargin)
%This function computes the degree d_hat(i) and sparsity level s_hat(i).

%Authors: Ofir Lindenbaum, Jay S. Stanely III.

%Input 
%       data= data matrix. Rows are measurments, columns are features.
% varargin:
%      'method' (default = 'std')
%       This sets the method for estimating the kernel bandwidth.
%       Options: 'std'- standard deviation of the distances, 'minmax'-  min-max on the distance matrix
%       'median'- the median of the distances   
%       'sigma'  (deafault=[])
%       User defined sigma

%Output
%       d_hat= a vector with the degree at each point
%       s_hat= the sparsity measure at each point, default s_hat=1./d_hat
%       sigma= the estimated sigma
%  

method='std';
sigma=[];



for i=1:length(varargin)
    % adaptive k-nn bandwidth
    if(strcmp(varargin{i},'method'))
       method =  lower(varargin{i+1});
    end
    if(strcmp(varargin{i},'sigma'))
       sigma =  lower(varargin{i+1});
    end
end

N=size(data,2);
D=pdist2(data, data);

if isempty(sigma)
    if strcmp(method,'minmax')
        MinDv=min(D+eye(size(D))*10^15);
        eps_val=(max(MinDv));
        sigma=2*(eps_val)^2;
    elseif strcmp(method,'median')
        sigma=median(median(D));
    else
        sigma=std(mean(D));
    end
    
end
%Compute kernel elements
K=exp(-(D.^2/(2*sigma^2))); 
p = sum(K);
d_hat=p*(N)/sum(p);

s_hat=1./d_hat;


end

