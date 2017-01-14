

function K = rbfKernelM(X, param)
  % N: number of samples
  N = size(X, 1);
  K = pdist(X, 'euclidean').^2;
  K = exp(-K/param);
  K = squareform(K);
  K = K + eye(N);
end
