function saveQuantizedParametersVerilog(net)
% This function takes a MATLAB neural network and exports the quantized
% parameters into a verilog LUT.

% Get quantization details
details = quantizationDetails(net);

% Specify output file for saving Verilog parameters
outputFile = './model_parameters_quantized.v';

% Open the output file for writing
fileID = fopen(outputFile, 'w');

% Loop through the quantized learnables
for i = 1:height(details.QuantizedLearnables)
    learnable = details.QuantizedLearnables(i, :);
    
    % Extract layer name and parameter type (weights or biases)
    layerName = learnable.Layer{1};
    paramName = learnable.Parameter{1};
    values = learnable.Value{1}(:); % Flatten the parameter values
    dataType = class(values); % Get the original data type
    
    % Determine Verilog type based on MATLAB type
    if strcmp(dataType, 'int8')
        verilogType = '8''sd';
    elseif strcmp(dataType, 'int16')
        verilogType = '16''sd';
    elseif strcmp(dataType, 'int32')
        verilogType = '32''sd';
    else
        error('Unsupported data type: %s', dataType);
    end
    
    % Create a unique name for the parameter in Verilog
    verilogParamName = sprintf('%s_%s', layerName, paramName);
    
    % Write the parameter as a Verilog localparam
    fprintf(fileID, 'localparam [0:%d][%d:0] %s = {', numel(values) - 1, str2double(verilogType(1:find(verilogType == '''', 1) - 1)) - 1, verilogParamName);
    for j = 1:numel(values)
        if j < numel(values)
            fprintf(fileID, '%s%d, ', verilogType, values(j));
        else
            fprintf(fileID, '%s%d};\n', verilogType, values(j));
        end
    end
    fprintf(fileID, '\n'); % Add a new line for clarity
end

% Close the file
fclose(fileID);

fprintf('Verilog parameters have been saved to %s\n', outputFile);
end