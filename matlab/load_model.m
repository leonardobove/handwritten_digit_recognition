% Load model
modelpath = "./traced_model.pt";
net = importNetworkFromPyTorch(modelpath);

% Add input layer to load images
InputSize = [1 196];
inputLayer = imageInputLayer(InputSize,Normalization="none");%"zscore", Mean=0.1307, StandardDeviation=0.3081);
net = addInputLayer(net,inputLayer,Initialize=true);

% Test NN
prob = predict(net, XTestPooled_dlarray);
prob = reshape(prob, 10000, 10);
[~, prediction] = max(prob, [], 2);
prediction = prediction;
YTest_double = double(YTest)-1;
equalElements = prediction == YTest_double;
numEqualElements = sum(equalElements);
totalElements = numel(YTest_double);

% Calculate the accuracy
accuracy = (numEqualElements / totalElements) * 100;
disp(accuracy); 



