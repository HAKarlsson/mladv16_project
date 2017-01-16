% Author: Henrik
% base program for testing on USPS data
function usps_KPCA()

load('data/usps_data.mat')
load('data/usps_noisy_test.mat')

X = single(trainData(:, 2:257)); % first column consists of labels
% specifying kernel to be used
param = 256*0.93;
[kernel, kernelM] = make_kernel('rbf', param);

str = sprintf('data/usps_alpha(%d).mat', param);
if ~exist(str) % if we have computed the alpha vectors already
  % !!! This can take some time.
  display('Calculating alphas from training data');
  [~, alpha, ~] = kpca(X, kernelM, 256);
  save(str, 'alpha', '-v7')
else
  display('Loading alphas from file');
  load(str)
end

% Good looking numbers
% because the USPS dataset contains VERY ugly number so we handpick those that
% would actually be representative.
imgID = [3,51,101,151,201,251,305,353,403,451];

display('Denoising samples');
gaussianSamples = gaussianTest(imgID,2:257);
speckleSamples = speckleTest(imgID,2:257);
for comp=[1, 4, 16, 64, 256]
  printf('number of components = %d\n', comp);

  a = alpha(:,1:comp);
  ZGaussian = multi_denoise(gaussianSamples, X, a, kernel, 2000);
  ZSpeckle = multi_denoise(speckleSamples, X, a, kernel, 2000);

  image = usps_matrix2images(ZGaussian);
  imwrite(image, sprintf('fig/usps/KPCAGaussian%3.0fp%.3d.jpg', param, comp));

  image = usps_matrix2images(ZSpeckle);
  imwrite(image, sprintf('fig/usps/KPCASpeckle%3.0fp%.3d.jpg', param, comp));
end
