

function K = calculate_kernelmatrix(X, kernel)

  [m, n] = size(X);

  % Calculate Kernel Matrix K using its symmetry
  K = zeros(m);
  for i = 1:m
    for j = (i+1):m
      K(i,j) = kernel(X(i, :), X(j, :));
    end
  end

  K = K + K';
  for i = 1:m
    K(i, i) = kernel(X(i, :), X(i, :));
  end

  % centered kernel matrix
  l = ones(m) / m;
  K = K - l*K - K*l + l*K*l;

end

