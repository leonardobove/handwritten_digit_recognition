function netTrained = train()
% Create and train a MLP neural network for handwritten digit recognition

options = trainingOptions("sgdm", ...
    InitialLearnRate=1, ...
    LearnRateSchedule="piecewise", ...
    LearnRateDropFactor=0.2, ...
    LearnRateDropPeriod=10, ...
    MaxEpochs=10, ...
    Verbose=false, ...
    Plots="training-progress", ...
    Metrics="accuracy");

% Load training data
load_dataset;

% Convert to one-hot encoding
YTrain_onehot = onehotencode(categorical(YTrain),2);

% Define the network architecture
layers = [
    featureInputLayer(196)
    fullyConnectedLayer(30)
    sigmoidLayer
    fullyConnectedLayer(10)
    sigmoidLayer];

% Train net
netTrained = trainnet(XTrain, YTrain_onehot, layers, "mse", options);
end