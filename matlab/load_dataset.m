% This script loads the MNIST handwritten digit recognition dataset
% and formats it as an array of input features of size [batch_size 196].
% It aldo loads the targets as an array of size [batch_size 1].

% Load the MNIST dataset
XTrain = loadMNISTImages("./mnist_dataset/train-images.idx3-ubyte");
YTrain = loadMNISTlabels("./mnist_dataset/train-labels.idx1-ubyte");
XTest = loadMNISTImages("./mnist_dataset/t10k-images.idx3-ubyte");
YTest = loadMNISTlabels("./mnist_dataset/t10k-labels.idx1-ubyte");

train_batchsize = size(XTrain, 3);
test_batchsize = size(XTest, 3);

% Reshape the input images into the 'SSCB' format
XTrain = reshape(XTrain, [28 28 1 train_batchsize]);
XTest = reshape(XTest, [28 28 1 test_batchsize]);


% Define a simple neural network with only the average pooling layer.
% This will also normalize the MNIST dataset
layers = [
    imageInputLayer([28 28 1], Normalization="none")
    averagePooling2dLayer(2, 'Stride', 2)
    ];

% Create the dlnetwork object
averager_net = dlnetwork(layers);

% Apply the pooling to the training set
dlXTrain = dlarray(XTrain, 'SSCB');
dlYPooledTrain = predict(averager_net, dlXTrain);

% Apply the pooling to the test set
dlXTest = dlarray(XTest, 'SSCB');
dlYPooledTest = predict(averager_net, dlXTest);

% Convert back to numeric arrays
XTrainPooled = extractdata(dlYPooledTrain);
XTestPooled = extractdata(dlYPooledTest);

% Display some pooled images from the training set
%figure;
%for i = 1:9
    %subplot(3, 3, i);
    %imshow(XTrainPooled(:, :, 1, i));
    %title(sprintf('Digit %d', YTrain(i)));
%end

% Flatten input data and convert it to dlarray
XTrain = reshape(XTrainPooled, [196 train_batchsize])';
XTest = reshape(XTestPooled, [196 test_batchsize])';

