

function K = calculate_kernelmatrix(X, kernel)
  % N: number of samples
  [N, _] = size(X);

  % Calculate Kernel Matrix K using its symmetry
  K = zeros(N);
  for i = 1:N
    for j = (i+1):N
      K(i,j) = kernel(X(i, :), X(j, :));
    end
  end

  K = K + K';
  for i = 1:N
    K(i, i) = kernel(X(i, :), X(i, :));
  end

  % centralize kernel matrix
  l = ones(N) / N;
  K = K - l*K - K*l + l*K*l;

end
