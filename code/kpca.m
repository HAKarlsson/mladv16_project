% Authors: Wenyi, Henrik
% Kernel PCA
function [eigenvalue, eigenvectors, projectInvectors] = kpca(X, kernel, targetDim)
  % Kernel PCA with a given target dimension
  [m, n] = size(X);  % Input data set m*n

  % Calculate Kernel Matrix K
  K = calculate_kernelmatrix(X, kernel);

  % eigenvectors and eigenvalue
  [v, e] = eig(K);
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


  % Calculate alphas, betas, gammas
  l = m
  alphas = ones(l, l); % FIXME: ??? - Markus

  betas = zeros(l, 1);
  for k=1:l
    for i=1:l
      % FIXME
      % betas(k) = betas(k) + a(k, i) * K(
    end
  end

  gammas = ones(l, 1);
  for i=1:l
    gammas(i) = betas' * alphas(:, i);
  end

  % Do the recursive step calculating z in eq 10?

  % calculate the projection in selected eigen space
  projectInvectors = K*eigenvectors;
end
