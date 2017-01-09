% Authors: Wenyi, Henrik
% Kernel PCA
function [lambdas, alphas, betas] = kpca(X, kernel, targetDim)
  % Kernel PCA with a given target dimension
  [N, _] = size(X);  % Input data set m*n

  % Calculate centralized Kernel Matrix K
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

  % normalize V
  v = v./repmat(sqrt(N*e),1,size(e))';

  % alphas: eigenvectors of K
  % lambdas = eigenvalues of K
  % (See equation 3 in the main paper)
  alphas = v(:, 1:targetDim);
  lambdas = N*e(1:targetDim);

  % calculate the projection in selected eigen space ?
  betas = K*alphas;
end
