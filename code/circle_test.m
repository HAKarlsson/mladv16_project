
function circle_test()

%% The circle test case of Toy Example 2

% make half a circle
sigma = 0.05;
x = -1:0.01:1;
x = x';
y = sqrt(ones(length(x), 1) - x.^2);

X = [x, y];
N = size(X, 1);

param = 2*sigma^2;
kernel = make_kernel('rbf', param);

[~, alphas, ~] = kpca(X, kernel, 2);


% The train data is the generated half circle. The train data is the generated
% half circle where each point has been shifted according to a Gaussian.

% add noise
x_n = normrnd(x, sigma, [N, 1]);
y_n = normrnd(y, sigma, [N, 1]);

train_data = [x, y];
test_data = [x_n, y_n];

z = zeros(N, 2);
for i=1:N
    z(i,:) = denoise(test_data(i,:), train_data, alphas, kernel);
end

% Plot the kpca of the half circle
figure()
hold on
plot(x, y, 'DisplayName', sprintf('Training Data'));
plot(x_n, y_n, 'x', 'DisplayName', sprintf('Test Data'));
plot(z(:,1), z(:,2), 'o', 'DisplayName', sprintf('Denoised Data'));
legend('-DynamicLegend');
saveas(gcf, 'fig/kpca_circle.png');


kernel = make_kernel('poly', 1);
% [~, alphas, ~, ~, ~, ~] = pca(train_data, 'Centered', true, 'NumComponents', 2);
[~, alphas, ~] = kpca(train_data, kernel, 2);


z_plain = zeros(size(X));
for i=1:N
    z_plain(i, :) = denoise(test_data(i, :), train_data, alphas, kernel);
end

figure()
hold on
plot(x, y, 'DisplayName', sprintf('Training Data'))
plot(z_plain(:, 1), z_plain(:, 2), 'o', 'DisplayName', sprintf('Denoised Data'))
saveas(gcf, 'fig/pca_circle.png');


