function random_points=data_generation(data,l_hat,sigma_n)

%This function generates the data

%Authors: Ofir Lindenbaum, Jay S. Stanely III.

%Input 
%       data= d_hat, degree estimate.
%       l_hat=number of points to generate
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

