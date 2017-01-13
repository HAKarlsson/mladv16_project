% Author Henrik
% kernelType: kernel type
% params: kernel parameters (array to allow multiparam kernels)
% ret: Kernel as an anonymous function
function kernel=make_kernel(kernelType, param)
  switch kernelType
    case 'rbf' % Radial Basis Function / Gaussian Kernel
      kernel = @(x,y) exp(-1 / param * sum((repmat(x, [size(y, 1), 1]) - y).^2, 2));
    case 'poly' % Polynomial Kernel
      kernel = @(x,y) (sum(repmat(x, [size(y, 1), 1]) .* y, 2) + 1).^param;
  end
