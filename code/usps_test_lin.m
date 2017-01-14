% Author: Henrik
% base program for testing on USPS data
%function usps_test_lin()

% usps_data.mat contains:
% trainData: 3000 samples, 300 of each number
% testData:  500 samples, 50 of each number
load('data/usps_data.mat')

% usps_noisy_test.mat contains:
% speckleTest:  test data with "speckle" noise
% gaussianTest: test data with gaussian noise
% 500 samples, 50 of each number
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
  % ==== DENOISING PART ===
  % A noisy sample
  z = ((gaussianTest(c, 2:257) * ev) * ev');
  z = z .* repmat(Xstd, size(c)) + repmat(Xmean, size(c));

  Im = usps_matrix2images(z);
  I = mat2gray(Im, [1, -1]);
  imwrite(I, sprintf('fig/usps_lin_gaussian%3.3d.jpg', comp));
end

for comp=[1, 4, 16, 64, 256]
  printf('comp = %d\n', comp)
  ev = eigvec(:,1:comp);
  % ==== DENOISING PART ===
  % A noisy sample
  z = ((speckleTest(c, 2:257) * ev) * ev');
  z = z .* repmat(Xstd, size(c)) + repmat(Xmean, size(c));

  Im = usps_matrix2images(z);
  I = mat2gray(Im, [1, -1]);
  imwrite(I, sprintf('fig/usps_lin_speckle%3.3d.jpg', comp));
end
