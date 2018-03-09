function [data_imputed, diffusion_operator] = magic(data,kernel,t)
%This function normalizes the kernel and applies it for time value t
diffusion_degrees = diag(sum(kernel,2).^(-1));
diffusion_operator = diffusion_degrees*kernel;
clear diffusion_degrees gauss_kernel

data_imputed = diffusion_operator^t * data;
data_imputed = (data_imputed);
end