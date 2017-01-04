clear all;
close all;
clc;

% generating linearly unclusterable data
if exist('X1.mat')
    load 'X1.mat'
    load 'X2.mat'
    load 'X3.mat'
    X1=X1';
    X2=X2';
    X3=X3';
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
else
    [X1, X2, X3] = generate_data();
    save 'X1.mat'  X1
    save 'X2.mat'  X2
    save 'X3.mat'  X3
end

X = [X1 X2 X3];
[nFea, nSmps] = size(X);
nClsSmps = nSmps / 3;

% PCA
[vec_pca, Y_pca, value_pca] = princomp(X');
Y_pca = Y_pca';

figure(2);
plot(Y_pca(1, 1 : nClsSmps),Y_pca(2, 1 : nClsSmps), 'ro');
hold on;
plot(Y_pca(1, nClsSmps + 1 : 2 * nClsSmps),Y_pca(2, nClsSmps + 1 : 2 * nClsSmps), 'g*');
hold on;
plot(Y_pca(1, 2 * nClsSmps + 1 : end),Y_pca(2, 2 * nClsSmps + 1 : end), 'b.');
hold on;
title('PCA');
xlabel('first dimension');
ylabel('second dimension');
saveas(gcf, 'PCA_Projection.jpg')

% KPCA
percent = 1;
var   = 2; % 1 means Gaussian Kernel?2-polynomial?3 linear kernel
sigma = 6; % kernel parameter
[vec_KPCA, value_KPCA, Y_pca] = kpca(X', sigma, var, 2);
Y_pca = Y_pca';

figure(3);
plot(Y_pca(1, 1 : nClsSmps),Y_pca(2, 1 : nClsSmps), 'ro');
hold on;
plot(Y_pca(1, nClsSmps + 1 : 2 * nClsSmps),Y_pca(2, nClsSmps + 1 : 2 * nClsSmps), 'g*');
hold on;
plot(Y_pca(1, 2 * nClsSmps + 1 : end),Y_pca(2, 2 * nClsSmps + 1 : end), 'b.');
hold on;
str = strcat('KPCA', '(p =', num2str(sigma), ')');
title(str);
xlabel('first dimension');
ylabel('second dimension');
str = strcat(str, 'KPCA_Projection.jpg')
saveas(gcf, str)