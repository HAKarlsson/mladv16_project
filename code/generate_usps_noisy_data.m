% == Generate noisy usps test data ==
% Author: Henrik Karlsson

% load trainData and testData
load('data/usps_data.mat')

labels = testData(:,1);
% Gaussian noise
gaussianTest = testData + normrnd(0, 0.5, size(testData));
gaussianTest = max(min(gaussianTest,1),-1);
gaussianTest(:,1) = labels; % restore labels

% 'Speckle' Noise
% flip flop, random bits turned to -1, 1 (black, white)
flip_flop = randi([0,1],size(testData));
% pick_pixel, 1 if we should flip flop the pixel
pick_pixel = rand(size(testData)) < 0.4;
% flip the selected pixels
speckleTest = pick_pixel.*flip_flop + ~pick_pixel.*testData;
speckleTest(:,1) = labels; % restore labels

% save matrices to the same file
save('data/usps_noisy_test.mat', '-v7', 'gaussianTest', 'speckleTest')
