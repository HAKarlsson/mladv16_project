

function K = calculate_kernelmatrix(X, kernel)
  % N: number of samples
  N = size(X, 1);
  K = pdist(X, kernel);
  K = squareform(K);
  self = kernel(X,X); % calculate the kernel with itself
  K = K + diag(self);
  % Centralize kernel matrix
  l = ones(N) / N;
  K = K - l*K - K*l + l*K*l;
end
