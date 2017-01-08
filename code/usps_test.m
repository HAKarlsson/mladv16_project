% Author: Henrik
% base program for testing on USPS data
page_screen_output(0);
page_output_immediately(1);

load 'data/usps_data.mat'

comp = 256;
kernel = MakeKernel('rbf', 0.5*comp);
display('Kernel PCA');

% !!! tmp. using test data because it is smaller, faster execution
[eigenvalue, eigenvectors, projectInvectors] = kpca(testData(:,2:257), kernel, comp);
size(eigenvalue)
size(eigenvectors)
size(projectInvectors)
