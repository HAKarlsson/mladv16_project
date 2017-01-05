% kernelType: kernel type
% params: kernel parameters (is array to allow multiparam kernels)
% ret: Kernel as an anonymous function
function kernel=MakeKernel(kernelType, param)
  switch kernelType
    case 'rbf' % Radial Basis Function / Gaussian Kernel
      kernel = @(x,y) exp((-norm(x-y)^2)/(2*param(1)^2));
    case 'poly' % Polynomial Kernel
      kernel = @(x,y) (sum(x.*y)+1)^param(1);
  end
