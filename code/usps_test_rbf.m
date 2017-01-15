% Author: Henrik
% base program for testing on USPS data
function usps_test_rbf()

% usps_data.mat contains:
% trainData: 3000 samples, 300 of each number
% testData:  500 samples, 50 of each number
load('data/usps_data.mat')

% usps_noisy_test.mat contains:
% speckleTest:  test data with "speckle" noise
% gaussianTest: test data with gaussian noise
% 500 samples, 50 of each number
load('data/usps_noisy_test.mat')

X = single(trainData(:, 2:257)); % first column consists of labels
% specifying kernel to be used
kernelType = 'rbf';
param = 256*0.93;
[kernel, kernelM] = make_kernel(kernelType, param);
[N, D] = size(X);
str = sprintf('data/usps_alpha(%s,%d,%d).mat', kernelType, param, D);
if ~exist(str) % if we have computed the alpha vectors already
  % !!! This can take some time.
  display('Calculating alphas from training data');
  [~, alpha, ~] = kpca(X, kernelM, D);
  save(str, 'alpha', '-v7')
else
  display('Loading alphas from file');
  load(str)
end

% Good looking numbers
% because the USPS dataset contains VERY ugly number so we handpick those that
% would actually be representative.
c = [3,51,101,151,201,251,305,353,403,451];

display('Denoising samples');
for comp=[1, 4, 16, 64, 256]
  printf('comp = %d\n', comp)
  % ==== DENOISING PART ===
  % A noisy sample
  z=[];
  % Now we will denoise x, z is the denoised x
  for i=c
    x = gaussianTest(i,2:257);
    zi = denoise(x, X, alpha(:,1:comp), kernel, 2000, 100);
    z = [z;zi];
  end
  Im = usps_matrix2images(z);
  I = mat2gray(Im, [1, -1]);
  imwrite(I, sprintf('fig/usps_%s_gaussian%3.3dp%3.0f.jpg', kernelType , comp, param));
end

for comp=[1, 4, 16, 64, 256]
  printf('comp = %d\n', comp)
  % ==== DENOISING PART ===
  % A noisy sample
  z=[];
  % Now we will denoise x, z is the denoised x
  for i=c
    x = speckleTest(i,2:257);
    zi = denoise(x, X, alpha(:,1:comp), kernel, 2000, 100);
    z = [z;zi];
  end
  Im = usps_matrix2images(z);
  I = mat2gray(Im, [1, -1]);
  imwrite(I, sprintf('fig/usps_%s_speckle%3.3dp%3.0f.jpg', kernelType, comp, param));
end
