

function K = calculate_kernelmatrix(X, kernel)
  % N: number of samples
  N = size(X, 1);

  K = pdist(X, kernel);
  K = squareform(K);
  for n=1:N
      K(n, n) = kernel(X(n), X(n));
  end

  % Centralize kernel matrix
  l = ones(N) / N;
  K = K - l*K - K*l + l*K*l;
end
