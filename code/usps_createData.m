% written for octave
load('data/usps_full_test.mat')
fullTest = testData;
testData = [];
for i=0:9
  samplesi = find(fullTest(:,1)==i);
  samplesi = samplesi(randperm(size(samplesi)));
  testData = [testData; fullTest(samplesi(1:50),:)];
end

load('data/usps_full_train.mat')
fullTrain = trainData;
trainData = [];
for i=0:9
  samplesi = find(fullTrain(:,1)==i);
  samplesi = samplesi(randperm(size(samplesi)));
  trainData = [trainData; fullTrain(samplesi(1:300),:)];
end
save('data/usps_data.mat','-v7','trainData','testData');
