% == Generate noisy usps test data ==
% Author: Henrik Karlsson

% load trainData and testData
load('data/usps_data.mat')
labels = testData(:,1);
% Gaussian noise
gaussianTest = testData + normrnd(0, 1, size(testData));
gaussianTest = max(min(gaussianTest,1),-1);
gaussianTest(:,1) = labels; % restore labels

% 'Speckle' Noise
% flip flop, random bits turned to 0, 1 (black, white)
flip_flop = randi([0,1],size(testData));
flip_flop(flip_flop == 0) = -1;
% pick_pixel, 1 if we should flip flop the pixel
pick_pixel = rand(size(testData)) < 0.4;
% flip the selected pixels
speckleTest = pick_pixel.*flip_flop + ~pick_pixel.*testData;
speckleTest(:,1) = labels; % restore labels

% save matrices to the same file
%save('data/usps_noisy_test.mat', '-v7', 'gaussianTest', 'speckleTest')
load data/usps_noisy_test.mat
c = [3,51,101,151,201,251,305,353,403,451]; % data number
z=[];
% Now we will denoise x, z is the denoised x
for i=c
  x = speckleTest(i,2:257);
  z = [z;x];
end
image = usps_matrix2images(z);
imwrite(image, sprintf('fig/usps_speckle.jpg'));

z=[];
% Now we will denoise x, z is the denoised x
for i=c
  x = gaussianTest(i,2:257);
  z = [z;x];
end
image = usps_matrix2images(z);
imwrite(image, sprintf('fig/usps_gaussian.jpg'));

z=[];
% Now we will denoise x, z is the denoised x
for i=c
  x = testData(i,2:257);
  z = [z;x];
end
image = usps_matrix2images(z);
imwrite(image, sprintf('fig/usps_test.jpg'));
