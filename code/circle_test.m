
function circle_test()

%% The circle test case of Toy Example 2

% make half a circle
sigma = 0.5;
x = [-1:0.005:-0.5 0.5:0.005:1]';
y = sqrt(ones(size(x)) - x.^2);

N = 1000;
r = rand(N, 1)*(1.3 - 0.7) + 0.7;
t = [60*rand(N/2, 1); 180-60*rand(N/2, 1)];

x_n = r .* cos(t * pi/180);
y_n = r .* sin(t * pi/180);

% X = [x, y];
N = size(x_n, 1);

% Perform the kPCA
param = 2*sigma^2;
[kernel, kernelM] = make_kernel('rbf', param);
[~, alphas, ~] = kpca([x, y], kernelM, 8);


% The training data is the generated half circle. The train data is the
% generated half circle where each point has been shifted according to a
% Gaussian.

% add noise
% x_n = normrnd(x, sigma, size(x));
% y_n = normrnd(y, sigma, size(y));

% d = 0.1;
% x_n = x + (rand(size(x)) * d - d/2);
% y_n = sqrt(ones(size(x)) - x.^2);
% y_n = y + (rand(size(y)) * d - d/2);

train_data = [x, y];
test_data = [x_n, y_n];

z = zeros(N, 2);
for i=1:N
    z(i, :) = denoise(test_data(i, :), train_data, alphas, kernel);
end

% Plot the kpca of the half circle
figure()
hold on
% plot(x, y, 'DisplayName', 'Training Data');
plot(x_n, y_n, '.', 'DisplayName', 'Noised Data');
plot(z(:, 1), z(:, 2), 'x', 'DisplayName', 'Denoised Data');
title('KPCA Denoising');
legend('-DynamicLegend');
saveas(gcf, 'fig/kpca_circle.png');


[kernel, kernelM] = make_kernel('poly', 1);
% [~, alphas, ~, ~, ~, ~] = pca(train_data, 'Centered', true, 'NumComponents', 2);
[~, alphas, ~] = kpca(train_data, kernelM, 2);

z_plain = zeros(size(test_data));
for i=1:N
    z_plain(i, :) = denoise(test_data(i, :), train_data, alphas, kernel);
end

figure()
hold on
plot(x_n, y_n, '.', 'DisplayName', 'Noised Data')
plot(z_plain(:, 1), z_plain(:, 2), 'x', 'DisplayName', 'Denoised Data')
title('PCA denoising');
legend('-DynamicLegend');
saveas(gcf, 'fig/pca_circle.png');
