% Author: Wenyi
function testKPCA()

% generating linearly unclusterable data, load if it already exists
<<<<<<< HEAD
[X1, X2, X3] = generate_data();
=======
<<<<<<< HEAD
[X1, X2, X3] = generate_data();
=======
if not(exist('data/testKPCA_data.mat'))
  [X1, X2, X3] = generate_data();
  save 'data/testKPCA_data.mat' X1 X2 X3
else
  load 'data/testKPCA_data.mat'
end
>>>>>>> dd43c9566b33e26b0262602b3b792dabaf26ba6c
>>>>>>> Wenyi

% Original data
figure(1)
hold on;
plot(X1(1, :), X1(2, :), 'ro')
plot(X2(1, :), X2(2, :), 'g*')
plot(X3(1, :), X3(2, :), 'b.')

title('Original Data');
xlabel('x_1');
ylabel('x_2');
saveas(gcf, 'fig/original_data.png')

% merge samples
X = [X1 X2 X3];
[nFea, nSmps] = size(X);
nClsSmps = nSmps / 3;

% remember samples partition
rSmpl = 1 : nClsSmps;                 % Red samples
gSmpl = nClsSmps + 1 : 2 * nClsSmps;  % Green samples
bSmpl = 2 * nClsSmps + 1 : nSmps;     % Blue samples

% PCA
[vec_pca, Y_pca, value_pca] = princomp(X');
Y_pca = Y_pca';

figure(2);
hold on;
plot(Y_pca(1, rSmpl),Y_pca(2, rSmpl), 'ro');
plot(Y_pca(1, gSmpl),Y_pca(2, gSmpl), 'g*');
plot(Y_pca(1, bSmpl),Y_pca(2, bSmpl), 'b.');

title('PCA');
xlabel('x_1');
ylabel('x_2');
saveas(gcf, 'fig/PCA_Projection.png')

% KPCA
percent = 1;
targetDim = 2;
% = Create kernel =
kernelType = 'rbf'; % polynomial kernel
params = 6; % kernel parameters
kernel = make_kernel(kernelType, params); % returns an anonymous function

% Perform KPCA
[value_KPCA, vec_KPCA, Y_KPCA] = kpca(X', kernel, targetDim);
Y_KPCA = Y_KPCA';

figure(3);
hold on;
plot(Y_KPCA(1, rSmpl),Y_KPCA(2, rSmpl), 'ro');
plot(Y_KPCA(1, gSmpl),Y_KPCA(2, gSmpl), 'g*');
plot(Y_KPCA(1, bSmpl),Y_KPCA(2, bSmpl), 'b.');

str = sprintf('KPCA(p=%d, kernel=%s)', params, kernelType);
title(str);
xlabel('x_1');
ylabel('x_2');
str = strcat('fig/', str, '.png');
saveas(gcf, str)