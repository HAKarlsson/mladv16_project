% Author: Henrik Karlsson

% number of components we should test with.
ks = 1:20;

% loading relevant data
load('data/usps_data.mat');
load('data/usps_alpha(rbf,128,256).mat'); % for kernel PCA, pre-computed alpha

X = trainData(:,2:257);
Y = testData(:,2:257);

% Train a linear PCA
[Ntrain, D] = size(X);
[Ntest, ~] = size(Y);
Xmean = mean(X);
Xstd = std(X);
Xcenter = (X - repmat(Xmean, [Ntrain,1])) ./ repmat(Xstd, [Ntrain,1]);
[eigvec, ~] = eigs(corr(Xcenter), 256);

XstdMat =  repmat(Xstd, [Ntest, 1]);
XmeanMat = repmat(Xmean, [Ntest, 1]);
meanSqDist = zeros(size(k,1),2);

for k = ks;
  ev = eigvec(:, 1:k);
  approx = ((Y * ev) * ev') .* XstdMat + XmeanMat;
  meanSqDist(k,1) = sum(sum((linXapprox - Y).^2, 2)) / Ntest;
end

[kernel, ~] = make_kernel('rbf', 128);
it = 0;
for k = ks;
  ev = alpha(:, 1:k);
  approx = [];
  for y = Y';
    it = it + 1
    yApprox = denoise(y', X, ev, kernel, 200);
    approx = [approx; yApprox];
  end
  meanSqDist(k,2) = sum(sum((rbfApprox - Y).^2, 2)) / Ntest;
end
