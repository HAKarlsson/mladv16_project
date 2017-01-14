
function box_test()

% Make a rectangle
x = 1:0.01:2;
y = x;
one = ones(length(x), 1);

% hold on
% plot(x, one, 'b-')
% plot(2*one, y, 'b-')
% plot(one, y, 'b-')
% plot(x, 2*one, 'b-')

sigma = 0.05;
data_train = [x', one; 2*one, y'; one,y'; x', 2*one];
data_test = normrnd(data_train, sigma, size(data_train));

N = size(data_train, 1);

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
legend('-DynamicLegend')
saveas(gcf, 'fig/pca_box.png');
