
clear all;
close all;
clc;
% generating linearly unclusterable data, load if it already exists
if not(exist('X1.mat'))
  [X1, X2, X3] = generate_data();
  save 'X1.mat'  X1
  save 'X2.mat'  X2
  save 'X3.mat'  X3
else
  load 'X1.mat'
  load 'X2.mat'
  load 'X3.mat'
  X1=X1';
  X2=X2';
  X3=X3';
end

% Original data
figure(1)
plot(X1(1, :),X1(2, :) ,'ro')
hold on;
plot(X2(1, :),X2(2, :),'g*')
hold on;
plot(X3(1, :),X3(2, :),'b.')
hold on;

title('original data');
xlabel('first dimension');
ylabel('second dimension');
saveas(gcf, 'original_data.jpg')

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
plot(Y_pca(1, rSmpl),Y_pca(2, rSmpl), 'ro');
hold on;
plot(Y_pca(1, gSmpl),Y_pca(2, gSmpl), 'g*');
hold on;
plot(Y_pca(1, bSmpl),Y_pca(2, bSmpl), 'b.');
hold on;
title('PCA');
xlabel('first dimension');
ylabel('second dimension');
saveas(gcf, 'PCA_Projection.jpg')

% KPCA
percent = 1;
targetDim = 2;
% = Create kernel =
kernelType = 'poly' % polynomial kernel
params = [6] % kernel parameters
kernel = MakeKernel(kernelType, params); % returns an anonymous function
% Perform KPCA
[value_KPCA, vec_KPCA, Y_KPCA] = kpca(X', kernel, targetDim);
Y_KPCA = Y_KPCA';

figure(3);
plot(Y_KPCA(1, rSmpl),Y_KPCA(2, rSmpl), 'ro');
hold on;
plot(Y_KPCA(1, gSmpl),Y_KPCA(2, gSmpl), 'g*');
hold on;
plot(Y_KPCA(1, bSmpl),Y_KPCA(2, bSmpl), 'b.');
hold on;
str = sprintf('KPCA(p=%d)', params(1));
title(str);
xlabel('first dimension');
ylabel('second dimension');
str = strcat(str, 'KPCA_Projection.jpg');
saveas(gcf, str)
