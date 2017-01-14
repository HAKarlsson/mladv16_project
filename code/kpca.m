% Authors: Wenyi, Henrik
% Kernel PCA
function [lambdas, alphas, projectInvectors] = kpca(X, kernelM, dim)
  % N: number of samples

  % Calculate centralized Kernel Matrix K
  K = kernelM(X);
  % Centralize kernel matrix
  N = size(X, 1);
  l = ones(N) / N;
  K = K - l*K - K*l + l*K*l;

  % eigenvectors and eigenvalue
  % (N*lambda)*alpha = K*alpha
  % therefore, alpha = eigvec and N*lambda = eigval
  [eigvec, eigval] = eig(K);
  eigval = diag(eigval);

  % filter away zero eigenvalues
  eigvec = eigvec(:, eigval > 0);
  eigval = eigval(eigval > 0);

  % selecting eigenvalues and eigenvectors
  [eigval, index] = sort(eigval, 'descend');
  eigvec = eigvec(:, index);
  % alphas: eigenvectors of K
  % lambdas: eigenvalues of K
  % (See equation 3 in the main paper)
  alphas  = eigvec(:, 1:dim);
  lambdas = eigval(1:dim);
  alphas  = alphas ./ repmat(sqrt(lambdas'), [N,1]);
  % Calculate the projection in selected eigen space
  projectInvectors = K*alphas;
end
