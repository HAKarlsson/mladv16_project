%% Toy Example 2
clc
clear all
close all

sigma = 0.05;
%% % make half a circle

x = -1:0.01:1;
x = x';
y = sqrt(ones(length(x),1)-x.^2);

% noise 
y_n = normrnd(y,sigma,[length(y),1]); 
x_n = normrnd(x,sigma,[length(y),1]);
% dataset y_n
para = sigma;
%[Y, eigVector, eigValue] = kPCA(y,4,'gaussian',para);
[Y, eigVector, eigValue] = kPCA([x,y],4,'gaussian',para);

test_data = [x_n,y_n];
train_data = [x,y];

para = 2*sigma^2;
kernel = make_kernel('rbf', para);
h_input = waitbar(0,'Wait...');


z = zeros(length(y_n),2);
for i=1:size(y_n,1) % 33
    %PI(i,:) = kPCA_PreImage(Y(i,:)',eigVector,y_n,para);
    
    z(i,:) = denoise(test_data(i,:), train_data, eigVector, kernel);
    
    %PI = denoise(data_test(:,i), data_train, alphas, kernel)
    %disp(i);
    waitbar(i/size(y_n,1))
end
figure()
plot(x,y,'DisplayName',sprintf('Training Data'))
hold on
plot(x,y_n,'x','DisplayName',sprintf('Test Data'))
hold on
plot(z(:,1),z(:,2),'o','DisplayName',sprintf('Denoised Data'));
legend('-DynamicLegend')

% % plain PCA for half circle
% [coeff,score,latent,tsquared,explained,mu] = pca(test_data,'Centered',true,'NumComponents',2);
% %You can reconstruct the original data using score*coeff'.
% res = score*coeff'+ ones(size(train_data,1),1)*mu;

kernel = make_kernel('poly',1);
[coeff,score,latent,tsquared,explained,mu] = pca(train_data,'Centered',true,'NumComponents',2);

z_plain = zeros(length(y_n),2);
for i=1:size(y_n,1) % 33
    
    z_plain(i,:) = denoise(test_data(i,:), train_data, score, kernel); % score is the eigenvectors
    waitbar(i/size(y_n,1))
end

figure()
plot(x, y, 'DisplayName', sprintf('Training Data'))
hold on
plot(z_plain(:,1), z_plain(:,2), 'o','DisplayName', sprintf('Denoised Data'))


%% make a rectangle 
x = 1:0.01:2;
y = x;
one = ones(length(x),1);
% plot(x,one,'b-')
% hold on
% plot(2*one,y,'b-')
% hold on
% plot(one,y,'b-')
% hold on
% plot(x,2*one,'b-')
sigma = 0.05;
data_train = [x',one;2*one,y';one,y';x',2*one];
data_test = normrnd(data_train, sigma, size(data_train));




%dataset data_train_n
para = sigma;
[Y, eigVector, eigValue] = kPCA(data_train,6,'gaussian',para);

% test_data = [x,y_n];
% train_data = [x,y];

para = 2*sigma^2;
kernel = make_kernel('rbf', para);
h_input = waitbar(0,'Wait...');


z = zeros(size(data_test));
for i=1:size(data_test,1) % 33
    %PI(i,:) = kPCA_PreImage(Y(i,:)',eigVector,y_n,para);
    
    z(i,:) = denoise(data_test(i,:), data_train, eigVector, kernel);
    
    %PI = denoise(data_test(:,i), data_train, alphas, kernel)
    %disp(i);
    waitbar(i/size(data_test,1))
end

figure()
plot(data_train(:,1),data_train(:,2),'o','DisplayName',sprintf('Training Data'))
hold on
plot(data_test(:,1),data_test(:,2),'x','DisplayName',sprintf('Test Data'))
hold on
plot(z(:,1),z(:,2),'*','DisplayName',sprintf('Denoised Data'))
legend('-DynamicLegend')
%% Linear PCA
kernel = make_kernel('poly',1);
[Y, eigVector, eigValue] = kPCA(data_train, 1, 'poly', 1);
%[coeff,score,~,~,~,mu] = pca(data_train,'Centered',true,'NumComponents',2);
%res = score*coeff' + ones(size(data_train,1))*mu';
z_plain = zeros(size(data_test));
for i=1:size(data_test,1) % 33
    
    z_plain(i,:) = denoise(data_test(i,:), data_train, eigVector, kernel); % score is the eigenvectors
    waitbar(i/size(data_test,1))
end

figure()
plot(data_train(:,1), data_train(:,2),'o', 'DisplayName', sprintf('Training Data'))
hold on
plot(z_plain(:,1), z_plain(:,2), 'o','DisplayName', sprintf('Denoised Data'))

