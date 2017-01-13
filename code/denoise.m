% Author: Henrik
% Denoising x
% == Input ==
% x:      variable to be denoised
% X:      training data
% alpha:  eigenvector of the centralized kernel matrix
% kernel: the kernel function
%
% Output: z: denoised x
function z = denoise(x, X, alpha, kernel)
  % get the
  N = size(X, 1);

  % Calculate the beta vector
  kern_v = zeros(N,1);
  for n=1:N
    kern_v(n) = kernel(x, X(n,:));
  end
  beta = alpha' * kern_v;

  % Calculate the gamma vector
  gamma = alpha * beta;

  % Calculater pre image
  z = x; % x as initial guess
  z_old = zeros(size(z));
  while (norm(z-z_old) > 10^-8)
    z_old = z;
    num = zeros(size(x));
    denum = 0;
    fac = kernel(X,z).*gamma;
    num = fac' * X;
    denum = sum(fac);
    z = num / denum;
  end
end
