function [eigenvalue, eigenvectors, project_invectors] = kpca(x, sigma, cls, target_dim)
  % Kernel PCA with a given target dimension
  psize=size(x);  % Input data set m*n
  m=psize(1);   % Sample Number
  n=psize(2);   % Sample Dimension


  % Calculate Kenel Matrix K
  l=ones(m,m);
  for i=1:m
    for j=1:m
     k(i,j)=kernel(x(i,:),x(j,:),cls,sigma);
    end
  end


  % centered kernel matrix
  kl=k-l*k/m-k*l/m+l*k*l/(m*m); 


  % eigenvectors and eigenvalue
  [v,e] = eig(kl);
  e = diag(e);


  % selecting eigenvalue and eigenvectors
  [dump, index] = sort(e, 'descend');
  e = e(index);
  v = v(:, index);
  rank = 0;
  for i = 1 : size(v, 2)
    if e(i) < 1e-6
      break;
    else
      v(:, i) = v(:, i) ./ sqrt(e(i));
    end
    rank = rank + 1;
  end
  eigenvectors = v(:, 1 : target_dim);
  eigenvalue = e(1 : target_dim);


  % projection
  project_invectors = kl*eigenvectors;  %calculate the projection in selected eigen space
end