% Author: Henrik
% Denoising multiple rows of data
% == Input ==
% Y:      variables to be denoised
% X:      training data
% alpha:  eigenvector of the centralized kernel matrix
% kernel: the kernel function
%
% Output: Z: denoised Y
function Z = multi_denoise(Y, X, alpha, kernel, max_iter, min_iter)

  if ~exist('max_iter', 'var')
    max_iter = 1000;
  end
  if ~exist('min_iter', 'var')
    min_iter = 0;
  end

  [M, ~] = size(Y);

  Z = [];
  for i=1:M
    z = Y(i,:);
    z = denoise(z, X, alpha, kernel, max_iter, min_iter);
    Z = [Z;z];
  end
end
