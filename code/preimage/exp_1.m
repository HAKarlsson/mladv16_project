clc
clear all
close all
rng(330)
dim = 10;
sigma = 0.85;
n = 11; % Number of features - up to 11
n_obs = 100; 

a = -1; 
b = 1;
cov_mat_diag = ((sigma)^2)*ones(dim,1);
cov_mat = diag(cov_mat_diag);
data_train = zeros(n_obs,11);
data_test = zeros(33,11);
for i=1:n
    
    r1 = unifrnd(a,b,[10,1]);
    r = mvnrnd(r1,cov_mat,15);
    r = reshape(r,[15*dim,1]);
    
    data_train(:,i) = r(1:100);
    data_test(:,i) = r(101:133);
end

data_train = data_train(:,1:n);

% figure()
% plot(data_train(:,1), data_train(:,2),'o')

% Centering
for i=1:n
data_train(:,i) = data_train(:,i) - mean(data_train(:,i))*ones(n_obs,1);
end

% % Compute the Gram matrix
% gram = zeros(n_obs,n_obs);
% for i = 1:n_obs
%     for j=1:n_obs
%         res = my_g_k(data_train(i,:), data_train(j,:),n,sigma);
%         gram(i,j) = res;
%     end
% end

% Calculate Kernel Matrix gram using its symmetry
gram = zeros(n_obs,n_obs);
for i = 1:n_obs
    for j = (i+1):n_obs
      gram(i,j) = my_g_k(data_train(i, :), data_train(j, :),n,sigma);
    end
end
gram = gram + gram';

for i = 1:n_obs
    gram(i, i) = my_g_k(data_train(i, :), data_train(i, :),n,sigma);
end


% Compute the centered Gram matrix 
o_n = 1/n_obs*ones(n_obs,n_obs);
K_cent = gram - o_n*gram - gram*o_n + o_n*gram*o_n;

opts.issym=1;                          
opts.disp = 0; 
opts.isreal = 1;
neigs = 30;

[V,D] = eigs(K_cent,[],neigs,'lm',opts); % V has eigenvectors,D has eigenvalues
% (N*lambda)*alpha = K*alpha
% therefore, alpha = eigvec and N*lambda = eigval
D = D ~= 0;
D = D./n_obs;

eigvals = diag(D);
norm_V = zeros(n_obs,n_obs);

for col = 1:size(V,2)

    V(:,col) = V(:,col)./(sqrt(D(col,col)));
end
[~, index] = sort(diag(D),'descend'); 
V = V(:,index); % the alphas

target_dim = 2;

data_out = zeros(target_dim,n_obs);
for count = 1:target_dim
    data_out(count,:) = V(:,count)'*K_cent'; % Projecting the data in lower dimensions
end
data_out = data_out'; % Kernel principal components. y_k 


% Plain PCA
[B, Zpca, evals, Xrecon, mu] = pcaPmtk(data_train, 2);

% Comparison
figure()
plot(data_out(:,1), data_out(:,2), 'x','DisplayName','kPCA')
hold on
plot(Zpca(:,1), Zpca(:,2), 'o','DisplayName','PCA')
legend('-DynamicLegend')
title('kPCA vs PCA', 'fontsize', 16);
xlabel('z_1')
ylabel('z_2')


% Reconstructing the Pre-Images

%   y: dimensionanlity-reduced data
%	eigVector: eigen-vector obtained in kPCA
%   X: data matrix
%   para: parameter of Gaussian kernel
%	z: pre-image of y

para = 2^2;

disp('Performing kPCA pre-image reconstruction...');
PI=zeros(size(data_test)); % pre-image
for i=1:size(data_test,1)
    PI(i,:)=kPCA_PreImage(data_out(i,:)',V,data_test,para)';
end

figure()
plot3(PI(1:2:end,1),PI(1:2:end,2),PI(1:2:end,3),'b*');
hold on;
plot3(PI(2:2:end,1),PI(2:2:end,2),PI(2:2:end,3),'ro');
title('Reconstructed pre-images of Gaussian kPCA');

% [r_eigvec, c_eigvec] = size(V);
% [r_prin_comp,~] = size(data_out);
% gammas = zeros(c_eigvec,1);
% 
% for cols=1:c_eigvec
%     
%     for k=1:r_prin_comp
%         tmp = data_out(k)*V(k,cols);
%         gammas(cols) = gammas(cols) + tmp;
%     end
% end

