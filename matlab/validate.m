dataDS = arrayDatastore(XTest, 'IterationDimension', 1);
labelsDS = arrayDatastore(categorical(YTest), 'IterationDimension', 1);
validationData = combine(dataDS, labelsDS);

options_emulation = dlquantizationOptions('Target','host','MetricFcn',{@(x)customAccuracyMetric(x,YTest)});
prediction_emulation = dlquantobj.validate(validationData,options_emulation);

% Display the accuracy
disp("Accuracy results:");
fprintf('%s: %.2f\n', string(prediction_emulation.MetricResults.Result.NetworkImplementation(1)),...
    prediction_emulation.MetricResults.Result.MetricOutput(1)*100);
fprintf('%s: %.2f\n', string(prediction_emulation.MetricResults.Result.NetworkImplementation(2)),...
    prediction_emulation.MetricResults.Result.MetricOutput(2)*100);

% Define a custom accuracy metric function
function accuracy = customAccuracyMetric(predictions, ground_truths)
    % Reshape output predictions
    predictions = reshape(predictions, [10 10000])';

    % Convert predictions to class labels
    [~, predictedLabels] = max(predictions, [], 2);
    predictedLabels = predictedLabels - 1; % Adjust for MATLAB indexing
    
    % Compute accuracy
    accuracy = sum(predictedLabels == double(ground_truths)) / numel(ground_truths);
end