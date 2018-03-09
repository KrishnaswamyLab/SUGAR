function sugar_gen_points=sugar(data,varargin)

%Authors: Ofir Lindenbaum, Jay S. Stanely III.

%Input 
%       data= data matrix. Rows are measurments, columns are features.
%   varargin:
%       sigma_n= badnwidth of Gaussian noise
%      'method' (default = 'std')
%       This sets the method for estimating the kernel bandwidth for degree.
%       Options: 'std'- standard deviation of the distances, 'minmax'-  min-max on the distance matrix
%       'median'- the median of the distances   
%       'sigma'  (deafault=[])
%       User defined sigma
%       sigma= bandwidth for degree

%       M= number of points to generate    
%       equalizeF= boolean variable to activate the density equalization 
%Output
%      sugar_gen_points: Y - new generated points 
%    

%Defaults
equalizeF=0;
sigma_n=[];
M=2*size(data,1);

for i=1:length(varargin)
     if(strcmp(varargin{i},'sigma_n'))
       sigma_n =  lower(varargin{i+1});
    end
    if(strcmp(varargin{i},'sigma'))
       sigma =  lower(varargin{i+1});
    end
    if(strcmp(varargin{i},'equalizeF'))
       equalizeF =  lower(varargin{i+1});
    end
end


n=length(varargin);
%Estimate the degree
[ d_hat,s_hat,sigma] = degree_sparsity_est(data,varargin{:,:});
%Update parameters
varargin{n+1}='sigma';
varargin{n+2}=sigma;
varargin{n+3}='equalizeF';
varargin{n+4}=equalizeF;
varargin{n+5}='dim';
varargin{n+6}=size(data,2);
n=length(varargin);

%If no parameter for noise is given then estimate local covariances
if isempty(sigma_n)
    [sigma_n] = local_cov_est(data,varargin{:,:});
    varargin{n+1}='sigma_n';
    varargin{n+2}=sigma_n;
end
%Estimate generation level (number of points to generate at each index)
[l_hat] = generation_level_est(d_hat,varargin{:,:});
%Generate points 
random_points=data_generation(data,l_hat,sigma_n);
%Compute and apply mgc magic
[sugar_gen_points] = mgc_magic(data,random_points,s_hat,varargin{:,:});



end

