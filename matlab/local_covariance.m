function [sigma_n] = local_covariance(data,varargin)
%This function computes local k-nn covariance matrices

%Authors: Ofir Lindenbaum, Jay S. Stanely III.

%Input 
%       data= data matrix. Rows are measurments, columns are features.
%   varargin:
%       k= number of nearest neighbors for local covariance

%       
%Output
%       sigma_n= a cell of local covariance matrices of the Gaussian
%                   generated noise. 
%     


%Defaults:
k=5;
 
for i=1:length(varargin)
    if(strcmp(varargin{i},'k'))
       k =  lower(varargin{i+1});
    end
    
end

for i=1:size(data,1)
        IDX = knnsearch(data,data(i,:),'K',k);
        sigma_n{i}=cov(data(IDX,:));
end

end
