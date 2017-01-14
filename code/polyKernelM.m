

function K = polyKernelM(X, param)
  % N: number of samples
  N = size(X, 1);
  K = X * X';
  K = (K + 1).^param;
end
