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
  % filter away zero eigenvalues
  v = v(:, e > 0);
  e = e(e > 0);
  % selecting eigenvalues and eigenvectors
  [e, index] = sort(e, 'descend');
  v = v(:, index);
  v = v./repmat(sqrt(e),1,size(e))'; % normalize V
  eigenvectors = v(:, 1:targetDim);
  eigenvalue = e(1:targetDim);

  % calculate the projection in selected eigen space
  projectInvectors = kl*eigenvectors;
end
