%% proj_work_1
function results = proj_work_1()


%% Data Creation
test_participants = 33; % Default 33
train_participants = 100; % Default 100

num_centers = 11; % how many centers - 11 default
num_dim = 10;     % how many dimensions - 10 default

% eleven centers of 10 dim (rows)
centers = unifrnd(-1, 1, [num_centers, num_dim]);


results = [];
for sigma=[0.05 0.1 0.2 0.4 0.8]

    % use a row as the mean, and diagonal cov mat
    cov_mat = sigma^2 * eye(num_dim);

    % Generate training and test data from each center
    data_test = [];
    data_train = [];
    for i=1:num_centers
        s = mvnrnd(centers(i, :), cov_mat, train_participants);
        data_train = [data_train; s];

        r = mvnrnd(centers(i, :), cov_mat, test_participants);
        data_test = [data_test; r];
    end

    % Calculate the PCAs using all possible dimensions. We crop them later.
    para = 2*sigma^2;
    [kernel, kernelM] = make_kernel('rbf', para);
    [~, alphas, ~] = kpca(data_train, kernelM, num_dim);

    [kernel2, kernel2M] = make_kernel('poly', 1);
    [~, alphas2, ~] = kpca(data_train, kernel2M, num_dim);

    res = [];
    for dim=1:(num_dim - 1)
        % Kernel PCA
        z = zeros(size(data_test));
        z_plain = zeros(size(data_test));
        for i=1:size(data_test, 1)
            z(i, :) = denoise(data_test(i, :), data_train, alphas(:, 1:dim), kernel);
            z_plain(i, :) = denoise(data_test(i, :), data_train, alphas2(:, 1:dim), kernel2);
        end

        %% Errors
        error_1 = 0;
        error_2 = 0;
        start = 1;

        for i=1:num_centers
            error_1 = error_1 + immse(repmat(centers(i, :), [test_participants, 1]), z_plain(start:start+test_participants-1, :));
            error_2 = error_2 + immse(repmat(centers(i, :), [test_participants, 1]),       z(start:start+test_participants-1, :));
            start = start + test_participants;
        end
        res = [res error_1/error_2]
    end
    results = [results; res]
end
results


