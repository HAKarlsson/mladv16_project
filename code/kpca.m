% Authors: Wenyi, Henrik
% Kernel PCA
function [eigenvalue, eigenvectors, projectInvectors] = kpca(X, kernel, targetDim)
  % Kernel PCA with a given target dimension
  % Sample Number, Sample Dimension
  [m, n] = size(X);  % Input data set m*n

  % Calculate Kernel Matrix K
  display('calculating kernel matrix')
  k = zeros(m);
  % calculate the upper right half/triangle first, matrix is symmetric
  for i = 1:m
    for j = (i+1):m
      k(i,j) = kernel(X(i,:), X(j,:));
    end
  end
  k += k'; % symmetry
  for i = 1:m
    k(i,i) = kernel(X(i,:), X(i,:));
  end

  % centered kernel matrix
  display('centering')
  l = ones(m)/m;
  kl = k - l*k - k*l + l*k*l;

  % eigenvectors and eigenvalue
  display('calculating eigenvalue and eigenvector')
  [v,e] = eig(kl);
  e = diag(e);

  % selecting eigenvalues and eigenvectors
  display('selecting eigenvalues and eigenvectors')
  [e , index] = sort(e, 'descend');
  v = v(:, index);
  rank = 0; % use?
  for i = 1 : size(v, 2)
    if e(i) == 0
      break;
    end
    v(:, i) = v(:, i)/sqrt(e(i));
    rank = rank + 1;
  end
  eigenvectors = v(:, 1 : targetDim);
  eigenvalue = e(1 : targetDim);

  % projection
  projectInvectors = kl*eigenvectors;  %calculate the projection in selected eigen space
  display('KPCA done.')
end
