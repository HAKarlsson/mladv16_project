% Authors: Wenyi, Henrik
% Kernel PCA
function [eigenvalue, eigenvectors, projectInvectors] = kpca(X, kernel, targetDim)
  % Kernel PCA with a given target dimension
  [m, n] = size(X);  % Input data set m*n

  % Calculate Kernel Matrix K using its symmetry
  k = zeros(m);
  for i = 1:m
    for j = (i+1):m
      k(i,j) = kernel(X(i, :), X(j, :));
    end
  end
  k += k'; % symmetry
  for i = 1:m
    k(i, i) = kernel(X(i, :), X(i, :));
  end

  % centered kernel matrix
  l = ones(m) / m;
  kl = k - l*k - k*l + l*k*l;

  % eigenvectors and eigenvalue
  [v,e] = eig(kl);
  e = diag(e);

  % selecting eigenvalues and eigenvectors
  [e, index] = sort(e, 'descend');
  v = v(:, index);
  for i = 1:size(v, 2)
    if e(i) == 0
      break;
    end
    v(:, i) = v(:, i) / sqrt(e(i));
  end
  eigenvectors = v(:, 1:targetDim);
  eigenvalue = e(1:targetDim);

  % calculate the projection in selected eigen space
  projectInvectors = kl*eigenvectors;
end
