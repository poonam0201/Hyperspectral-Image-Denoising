function denoised = denoiseHSI_temp(noisy,max_iter,lambda1,lambda2,alpha,del,epsilon)
% Denoise an image using the Tikhonov and 
% Total variation regularization (l2-l1)
%
%
% Default Arguments:
%   noisy : 	noisy image
%   max_iter  : number of iterations (100)
%   alpha     : step size (0.25)
%   nargin    : no. of input arguments
if nargin < 2
  max_iter = 100;
end

if nargin < 3
  %lambda = .0001;
  lambda1 = 0.001;
end

if nargin < 4
  %lambda = .0001;
  lambda2 = 0.001;
end

if nargin < 5
   del = 0.0001;
end

if nargin < 6
   epsilon = 0.0001;
end

if nargin < 7
  alpha = 0.25;
end

% compute the gradient and divergence filters
gx_filter = [0 -1 1];
gy_filter = [0 -1 1]';
gz_filter = reshape(gx_filter, [1 1 3]);
dx_filter = [-1 1 0];
dy_filter = [-1 1 0]';
dz_filter = reshape(dx_filter, [1 1 3]);

% initialize the estimate by the noisy image
denoised = noisy;

tmp1=zeros(size(noisy));
for iter = 1:max_iter
  
	l2=noisy-denoised;
    n=sqrt(l2.^2)+del;
    l1=(l2./n);
    fidelity=lambda1*l2+lambda2*l1;
	
    tmp=fidelity;
	%Compute lambda2 * div(grad(x)/|grad(x)|) 
  %Checks whether image contains only one channel
  if (size(denoised, 3) == 1)
    Gx = imfilter(denoised, gx_filter);
    Gy = imfilter(denoised, gy_filter);
    N = sqrt(Gx.^2 + Gy.^2) + epsilon;
    D = imfilter(Gx./N, dx_filter) + imfilter(Gy./N, dy_filter);
  else
    Gx = imfilter(denoised, gx_filter);
    Gy = imfilter(denoised, gy_filter);
    Gz = imfilter(denoised, gz_filter);
    N = sqrt(Gx.^2 + Gy.^2 + Gz.^2) + epsilon;
    D = imfilter(Gx./N, dx_filter) + imfilter(Gy./N, dy_filter) + imfilter(Gz./N, dz_filter);
  end
  %tmp = tmp + lambda2 *  D;
  tmp = tmp - lambda2*D;
  % update the estimate
  denoised = denoised - alpha * tmp;
  % apply positivity constraint
  denoised = max(0, denoised);
end
