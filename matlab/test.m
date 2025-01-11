function test(net)
% This function tests the accuracy of a given neural network,
% based on the MNIST dataset.

% Load dataset
load_dataset;

% Test network
prob = predict(net, XTest);

% Get maximum probability from output activations
[~, prediction] = max(prob, [], 2);
prediction = prediction - 1;

% Check against target
equalElements = prediction == double(YTest);
numEqualElements = sum(equalElements);
totalElements = numel(YTest);

% Calculate the accuracy
accuracy = (numEqualElements / totalElements);
disp(['Test Accuracy: ', num2str(accuracy * 100), '%']);
end