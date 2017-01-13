% Author: Henrik
% base program for testing on USPS data
function usps_test()

% usps_data.mat contains:
% trainData: 3000 samples, 300 of each number
% testData:  500 samples, 50 of each number
load 'data/usps_data.mat'
X = testData(:, 2:257); % first column consists of labels
% specifying kernel to be used
comp = 64;
kernelType = 'rbf';
param = 0.5*comp;
kernel = make_kernel(kernelType, param);

str = sprintf('data/usps_alpha(%s,%.2f,%d).mat', kernelType, param, comp);
if ~exist(str) % if we have computed the alpha vectors already
  % !!! This can take some time.
  display('Calculating alphas from training data');
  [~, alpha, ~] = kpca(X, kernel, comp);
  save(str,'alpha', '-v7')
else
  display('Loading alphas from file');
  load(str)
end

% usps_noisy_test.mat contains:
% speckleTest:  test data with "speckle" noise
% gaussianTest: test data with gaussian noise
% 500 samples, 50 of each number
load('data/usps_noisy_test.mat')


% ==== DENOISING PART ===
% A noisy sample
z=[];
% Now we will denoise x, z is the denoised x
for i=1:50:451
  x = gaussianTest(i,2:257);
  zi = denoise(x, X, alpha, kernel);
  z = [z;zi];
end
Im = usps_matrix2images(z);


I = mat2gray(Im, [1, -1]);
imshow(I);
