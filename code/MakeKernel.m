% Author Henrik
% kernelType: kernel type
% params: kernel parameters (array to allow multiparam kernels)
% ret: Kernel as an anonymous function
function kernel=MakeKernel(kernelType, param)
  switch kernelType
    case 'rbf' % Radial Basis Function / Gaussian Kernel
      kernel = @(x,y) exp(-1 / param * norm(x-y)^2);
    case 'poly' % Polynomial Kernel
      kernel = @(x,y) (sum(x.*y)+1)^param;
  end
