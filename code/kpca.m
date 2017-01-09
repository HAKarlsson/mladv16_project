% Authors: Wenyi, Henrik
% Kernel PCA
function [lambdas, alphas, projectInvectors] = kpca(X, kernel, targetDim)
  % N: number of samples
  [N, _] = size(X);  % Input data set m*n

  % Calculate centralized Kernel Matrix K
  K = calculate_kernelmatrix(X, kernel);

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
  alphas  = eigvec(:, 1:targetDim);
  lambdas = eigval(1:targetDim);

  % normalize V by using lambda*||alpha||^2 = 1
  alphas = alphas./repmat(sqrt(lambdas),1,size(lambdas))';

  % calculate the projection in selected eigen space
  projectInvectors = K*alphas;
  % projectInvectors == betas?
end
