% Author Henrik
% kernelType: kernel type
% params: kernel parameters (array to allow multiparam kernels)
% ret: Kernel as an anonymous function
function kernel=make_kernel(kernelType, param)
  isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
  if isOctave
    % program is octave
    switch kernelType
      case 'rbf' % Radial Basis Function / Gaussian Kernel
        kernel = @(x,y) exp(-1 / param * sum((x - y).^2, 2));
      case 'poly' % Polynomial Kernel
        kernel = @(x,y) (sum(x.*y, 2)+1)^param;
    end
  else
    % Program is matlab
    switch kernelType
      case 'rbf' % Radial Basis Function / Gaussian Kernel
        kernel = @(x,y) exp(-1 / param * sum((repmat(x, [size(y, 1), 1]) - y).^2, 2));
      case 'poly' % Polynomial Kernel
        kernel = @(x,y) (sum(x.*y, 2)+1)^param; % TODO: adapt to matlab
    end
  end
