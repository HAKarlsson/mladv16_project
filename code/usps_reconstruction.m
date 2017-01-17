% Author: Henrik
%function usps_compare()

load('data/usps_data.mat')
load('data/usps_noisy_test.mat')

X = single(trainData(:, 2:257)); % first column consists of labels
% N: number of samples
% D: dimension of samples
[N, D] = size(X);

% load KPCA data
param = 256*0.93;
[kernel, kernelM] = make_kernel('rbf', param);

path = sprintf('data/usps_alpha(%d).mat', param);
load(path)
% Centralize and normalize X
Xmean = mean(X);
Xstd = std(X);
Xcenter = (X - repmat(Xmean, [N, 1])) ./ Xstd;
[eigvec, eigval] = eigs(corr(Xcenter), 256);

% Good looking numbers
% because the USPS dataset contains VERY ugly number so we handpick those that
% would actually be representative.

Y = single(testData(:, 2:257));
[M, ~] = size(Y);
display('Denoising samples');
reconst_frac = [];
for comp=[1:20];
  printf('comp = %d\n', comp)
  ev = eigvec(:,1:comp);
  z = ((Y * ev) * ev');
  pca = z .* repmat(Xstd, [M, 1]) + repmat(Xmean, [M, 1]);
  kpca = multi_denoise(Y, X, alpha(:,1:comp), kernel, 100);
  error1 = 0;
  error2 = 0;
  for i=500;
    error1 = error1 + immse(pca, Y);
    error2 = error2 + immse(kpca, Y);
  end
  reconst_frac = [reconst_frac, error1/error2]
end
reconst_frac
