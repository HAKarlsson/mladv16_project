
function box_test()


% The side length r and the stroke width h
r = 1;
h = 0.4;

N = 1000;

% Make a rectangle
x = (-1:0.005:1)' * r;
one = r*ones(length(x), 1);


x1 = (2 + h)*rand(N/4, 1) - r - h/2;
y1 = r + rand(N/4, 1)*h - h/2;

x2 = (2 + h)*rand(N/4, 1) - r - h/2;
y2 = -r + rand(N/4, 1)*h - h/2;

% Some trickery to not make the corners overlap.
y3 = (2 - h)*rand(N/4, 1) - r + h/2;
x3 = -r + rand(N/4, 1)*h - h/2;

y4 = (2 - h)*rand(N/4, 1) - r + h/2;
x4 = r + rand(N/4, 1)*h - h/2;

% hold on;
% plot(x1, y1, '.');
% plot(x2, y2, '.');
% plot(x3, y3, '.');
% plot(x4, y4, '.');
% 
% plot(x, one, '.');
% plot(x, -one, '.');
% plot(one, x, '.');
% plot(-one, x, '.');
% xlim([-2, 2])
% ylim([-2, 2])


sigma = 0.50;
data_train = [x one; x -one; one x; -one x];
data_test = [x1 y1; x2 y2; x3 y3; x4 y4];
% data_train = [x', one; 2*one, y'; one,y'; x', 2*one];
% data_test = normrnd(data_train, sigma, size(data_train));

% N = size(data_train, 1);

% Perform kPCA
param = 2*sigma^2;
[kernel, kernelM] = make_kernel('rbf', param);
[~, alphas, ~] = kpca(data_train, kernelM, 12);

z = zeros(size(data_test));
for i=1:N
    z(i, :) = denoise(data_test(i, :), data_train, alphas, kernel);
end

figure()
hold on
plot(data_test(:, 1), data_test(:, 2), '.', 'DisplayName', 'Noised Data')
plot(z(:, 1), z(:,2), 'x', 'DisplayName', 'Denoised Data')
title('KPCA Denoising');
legend('-DynamicLegend')
saveas(gcf, 'fig/kpca_box.png');


% Compare to PCA
[kernel, kernelM] = make_kernel('poly', 1);
[~, alphas, ~] = kpca(data_train, kernelM, 1);

z = zeros(size(data_test));
for i=1:N
    z(i, :) = denoise(data_test(i, :), data_train, alphas, kernel);
end

figure()
hold on
plot(data_test(:, 1), data_test(:, 2), '.', 'DisplayName', 'Noised Data')
plot(z(:, 1), z(:, 2), 'x', 'DisplayName', 'Denoised Data')
title('PCA Denoising');
legend('-DynamicLegend')
saveas(gcf, 'fig/pca_box.png');
