%% proj_work_1
clc
clear all
close all
%% Parameters
sigma = 0.05;
dim = 3; % Number of components employed
%% Data Creation
test_participants = 10; % Default 33
train_participants = 40; % Default 100
num_centers = 11; % how many centers - 11 default
num_dim = 10; %how many dimensions - 10 default
centers = unifrnd(-1,1,[num_centers,num_dim]); % eleven centers of 10 dim (rows)

% use a row as the mean, and diagonal cov mat
cov_mat_diag = ((sigma)^2)*ones(num_dim,1);
cov_mat = diag(cov_mat_diag);

%data_test = zeros((33*num_centers),num_dim);
data_test = [];
data_train = [];
% data_train = zeros((100*num_centers),num_dim);

for i=1:11
r = mvnrnd(centers(1,:),cov_mat,test_participants); %each row has the samples times 15 rows! The test set
data_test=[data_test;r];
s = mvnrnd(centers(1,:),cov_mat,train_participants);
data_train =[data_train;s];
end

%% Kernel PCA

% Centering
% for i=1:num_dim
% data_train_c(:,i) = data_train(:,i) - mean(data_train(:,i))*ones(size(data_train,1),1);
% end

para = 2*sigma^2;
[kernel, kernelM]=make_kernel('rbf', para);
%[lambdas, alphas, projectInvectors] = kpca_team(data_train, kernel, dim);
[lambdas, alphas, projectInvectors] = kpca(data_train, kernelM, dim); Git

z = zeros(size(data_test));
h_input = waitbar(0,'Wait...');

for i=1:size(data_test,1) % 33
    z(i,:) = denoise(data_test(i,:), data_train, alphas, kernel);
    waitbar(i/size(data_test,1))
end

%% Linear PCA

[kernel, kernelM] = make_kernel('poly',1);
%[lambdas, alphas, projectInvectors] = kpca_team(data_train, kernel, dim);
[lambdas, alphas, projectInvectors] = kpca(data_train, kernelM, dim);
%[coeff,score,~,~,~,mu] = pca(data_train,'Centered',true,'NumComponents',2);
%res = score*coeff' + ones(size(data_train,1))*mu';
z_plain = zeros(size(data_test));
h_input = waitbar(0,'Wait...');
for i=1:size(data_test,1) % 33

    z_plain(i,:) = denoise(data_test(i,:), data_train, alphas, kernel); % score is the eigenvectors
    waitbar(i/size(data_test,1))
end
%% Errors
error_1 = immse(data_test,z_plain);
error_2 = immse(data_test,z);

result = error_1/error_2
