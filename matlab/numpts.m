function [l_hat] = numpts(d_hat,varargin)
%NUMPTS Compute the number of new points to generate around each point in a
%       dataset

%Authors: Ofir Lindenbaum, Jay S. Stanely III.

%Input 
%       data= d_hat, degree estimate.
%   varargin:
%       sigma= bandwidth of the degree estimate
%       sigma_n: 
%       Option A: a scalar Gaussian noise variance
%       Option B: a cell of local covariance matrices of the Gaussian
%                   generated noise. 
%       dim= the dimension of generated noise

%       
%Output
%       l_hat= the number of points to generate at each point
%     


%Defaults:
sigma=1;
sigma_n=1;

M=length(d_hat);
equalizeF=0;
for i=1:length(varargin)
    % adaptive k-nn bandwidth
    if(strcmp(varargin{i},'sigma'))
       sigma =  lower(varargin{i+1});
    end
    if(strcmp(varargin{i},'sigma_n'))
       sigma_n =  (varargin{i+1});
    end
     if(strcmp(varargin{i},'dim'))
       dim =  lower(varargin{i+1});
     end
     if(strcmp(varargin{i},'M'))
       M =  lower(varargin{i+1});
     end
    if(strcmp(varargin{i},'equalizeF'))
       equalizeF =  lower(varargin{i+1});
    end
end


 Const=max(d_hat);
 
 
if equalizeF
        if length(sigma_n)==1
                NumberEstimate=(Const-d_hat)*((sigma^2+sigma_n^2)/((2)*sigma_n^2))^(dim/2);
        else
            for i=1:length(d_hat)
                NumberEstimate(i)=(Const-d_hat(i))*det(sigma_n{i}^(-0.5)+(sigma_n{i}^(0.5))./(2*sigma^2));
            end
        end
else
    NumberEstimate=(Const-d_hat);
    NumberEstimate=NumberEstimate*M/sum(NumberEstimate);
end
l_hat=floor(NumberEstimate);
if sum(l_hat)==0
    error('l_hat=0, either provide M or decrease sigma_n');
elseif sum(l_hat)>10^4
    error('l_hat>1e4, either provide M or increase sigma');
end
end
