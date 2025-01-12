function quantizedNet = quantize_net(net)
% This function performs an int8 quantization of the input net.

% Create a quantizer object
quantObj = dlquantizer(net,'ExecutionEnvironment',"FPGA");

% Load representative input data for calibration
load_dataset;

% Calibrate the network
calibrate(quantObj, XTrain);

% Validate the quantized network
dataDS = arrayDatastore(XTest, 'IterationDimension', 1);
labelsDS = arrayDatastore(categorical(YTest), 'IterationDimension', 1);
validationData = combine(dataDS, labelsDS); % Create validation dataset

options_emulation = dlquantizationOptions('Target','host','MetricFcn',{@(x)customAccuracyMetric(x,YTest)});
prediction_emulation = quantObj.validate(validationData,options_emulation);

% Display the accuracy
disp("Accuracy results:");
fprintf('%s: %.2f\n', string(prediction_emulation.MetricResults.Result.NetworkImplementation(1)),...
    prediction_emulation.MetricResults.Result.MetricOutput(1)*100);
fprintf('%s: %.2f\n', string(prediction_emulation.MetricResults.Result.NetworkImplementation(2)),...
    prediction_emulation.MetricResults.Result.MetricOutput(2)*100);

% Convert the network to fixed-point
quantizedNet = quantize(quantObj);
end

% Define a custom accuracy metric function for validation process
function accuracy = customAccuracyMetric(predictions, ground_truths)
    % Reshape output predictions
    predictions = reshape(predictions, [10 10000])';

    % Convert predictions to class labels
    [~, predictedLabels] = max(predictions, [], 2);
    predictedLabels = predictedLabels - 1; % Adjust for MATLAB indexing
    
    % Compute accuracy
    accuracy = sum(predictedLabels == double(ground_truths)) / numel(ground_truths);
end