function [X1, X2, X3] = generate_data()
%Generating data
% 3 groups of sample, each size is 20
N_in_group = 40;
X1=zeros(N_in_group ,2);
X2=zeros(N_in_group ,2);
X3=zeros(N_in_group ,2);

r1=1*ones(N_in_group ,2);
r2=3*ones(N_in_group ,2);
r3=6*ones(N_in_group ,2);

theta1 = rand(1,N_in_group)*2*pi;
theta2 = rand(1,N_in_group)*2*pi;
theta3 = rand(1,N_in_group)*2*pi;
X1(:,1) = 1 * cos(theta1) + randn(1,N_in_group);
X1(:,2) = 1 * sin(theta1) + randn(1,N_in_group);
X2(:,1) = 3 * cos(theta2) + randn(1,N_in_group);
X2(:,2) = 3 * sin(theta2) + randn(1,N_in_group);
X3(:,1) = 6 * cos(theta3) + randn(1,N_in_group);
X3(:,2) = 6 * sin(theta3) + randn(1,N_in_group);
X1=X1';
X2=X2';
X3=X3';
end
