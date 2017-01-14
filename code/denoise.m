% Author: Henrik
% Denoising x
% == Input ==
% x:      variable to be denoised
% X:      training data
% alpha:  eigenvector of the centralized kernel matrix
% kernel: the kernel function
%
% Output: z: denoised x
function z = denoise(x, X, alpha, kernel, max_iter, min_iter)

  if ~exist('max_iter', 'var')
    max_iter = 1000;
  end
  if ~exist('min_iter', 'var')
    min_iter = 0;
  end
  % get the
  N = size(X, 1);

  % Calculate the beta vector
  x_m = repmat(x, [N,1]);
  kern_v = kernel(x_m, X);
  beta = alpha' * kern_v;

  % Calculate the gamma vector
  gamma = alpha * beta;
  gamma = gamma + 1 / N * (1 - sum(gamma));

  % Calculater pre image
  z = x; % x as initial guess
  z_old = zeros(size(z));
  iter = 0;
  while (norm(z-z_old) > 10^-8 && iter < max_iter || iter < min_iter)
    z_old = z;
    num = zeros(size(x));
    denum = 0;
    Z = repmat(z, [N, 1]);
    fac = kernel(Z, X) .* gamma;
    num = fac' * X;
    denum = sum(fac);
    z = num / denum;
    iter = iter + 1;
  end
  printf('Iterations: %d\n', iter);
end
