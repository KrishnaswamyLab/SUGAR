function [ new_data] = mgc_magic(X,Y,s_hat,varargin)
%This function computes the degree d_hat(i) and sparsity level s_hat(i).

%Authors: Ofir Lindenbaum, Jay S. Stanely III.

%Input 
%       data= data matrix. Rows are measurments, columns are features.
% varargin:
%  

%Output
%       new_data= noisy data after applying the mgc magic operation
%  

t=1;
fac=1;
a=2;
k=5;
method=1;

for i=1:length(varargin)
    % adaptive k-nn bandwidth
    if(strcmp(varargin{i},'t'))
       t =  lower(varargin{i+1});
    end
    if(strcmp(varargin{i},'a'))
       a =  lower(varargin{i+1});
    end
     if(strcmp(varargin{i},'k'))
       k =  lower(varargin{i+1});
     end
    if(strcmp(varargin{i},'method'))
       method =  lower(varargin{i+1});
    end
      if(strcmp(varargin{i},'fac'))
       method =  lower(varargin{i+1});
    end
end
        new_to_old = gauss_kernel(Y,X,a,k,method,fac);
        old_to_new = gauss_kernel(X,Y,a,k,method,fac);
     
        new_to_old_sparsity=bsxfun(@times,new_to_old,s_hat);
        mgc_kernel = new_to_old_sparsity*old_to_new; 
        [new_data, mgc_diffusion_operator] = magic(Y, mgc_kernel, t);
        if t~=0
        new_data = 0.99*max(max(X))*new_data/max(max(new_data));
        end 


end

