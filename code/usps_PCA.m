% Author: Henrik
% base program for testing on USPS data
function usps_PCA()

load('data/usps_data.mat')
load('data/usps_noisy_test.mat')

X = trainData(:, 2:257); % first column consists of labels
% N: number of samples
% D: dimension of samples
[N, D] = size(X);

% Centralize and normalize X
Xmean = mean(X);
Xstd = std(X);
Xcenter = (X - repmat(Xmean, [N, 1])) ./ Xstd;
[eigvec, eigval] = eigs(corr(Xcenter), 256);

% Good looking numbers
% because the USPS dataset contains VERY ugly number so we handpick those that
% would actually be representative.
c = [3,51,101,151,201,251,305,353,403,451]';

display('Denoising samples');
for comp=[1, 4, 16, 64, 256]
  printf('comp = %d\n', comp)
  ev = eigvec(:,1:comp);
  z = ((gaussianTest(c, 2:257) * ev) * ev');
  z = z .* repmat(Xstd, size(c)) + repmat(Xmean, size(c));

  image = usps_matrix2images(z);
  imwrite(image, sprintf('fig/usps_lin_gaussian%3.3d.jpg', comp));
end

for comp=[1, 4, 16, 64, 256]
  printf('comp = %d\n', comp)
  ev = eigvec(:,1:comp);
  z = ((speckleTest(c, 2:257) * ev) * ev');
  z = z .* repmat(Xstd, size(c)) + repmat(Xmean, size(c));

  image = usps_matrix2images(z);
  imwrite(image, sprintf('fig/usps_lin_speckle%3.3d.jpg', comp));
end
