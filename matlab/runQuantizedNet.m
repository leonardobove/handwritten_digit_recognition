function Y = runQuantizedNet(X)
% Example function to process input through the network.
% Used for code generation

    persistent qNet;

    if isempty(qNet)
        qNet = coder.loadDeepLearningNetwork('./mynet.mat', 'my_net');
    end

    % Predict output using the quantized network
    dlX = dlarray(X, 'C');
    dlY = predict(qNet, dlX);
    Y = extractdata(dlY);
end