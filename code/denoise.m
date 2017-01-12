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
  [N,_] = size(X);
  % Calculate the beta vector
  kern_v = zeros(N,1);
  for n=1:N
    kern_v(n) = kernel(x,X(n,:));
  end
  beta = alpha' * kern_v;
  % Calculate the gamma vector
  gamma = alpha * beta;
  % Calculater pre image
  z = x; % x as initial guess
  for i=1:100 % TODO: better break condition
    numerator = zeros(size(x));
    denumerator = 0;
    for n=1:N
      fac = kernel(z,X(n,:)) * gamma(n);
      numerator += X(n,:) * fac;
      denumerator += fac;
    end
    z = numerator / denumerator;
  end
