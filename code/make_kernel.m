% Author Henrik
% kernelType: kernel type
% params: kernel parameters (array to allow multiparam kernels)
% ret: Kernel as an anonymous function
function [kernel, kernelM]=make_kernel(kernelType, param)
  switch kernelType
    case 'rbf' % Radial Basis Function / Gaussian Kernel
      kernel = @(x, y) exp(-1 / param * sum((x - y).^2, 2) );
      kernelM = @(X) rbfKernelM(X, param);
    case 'poly' % Polynomial Kernel
      kernel = @(x, y) (sum(x .* y, 2) + 1).^param;
      kernelM = @(X) polyKernelM(X, param);
  end
end
