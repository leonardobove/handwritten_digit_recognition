function saveQuantizedParametersVerilog(net)
% This function takes a MATLAB neural network and exports the quantized
% parameters into a Verilog LUT with binary representation in 2's complement format.

% Get quantization details
details = quantizationDetails(net);

% Specify output file for saving Verilog parameters
outputFile = './model_parameters_quantized_binary.v';

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
    
    % Determine Verilog type and bit width based on MATLAB type
    if strcmp(dataType, 'int8')
        verilogType = '8''sb';
        bitWidth = 8;
        matlabType = 'int8';
    elseif strcmp(dataType, 'int16')
        verilogType = '16''sb';
        bitWidth = 16;
        matlabType = 'int16';
    elseif strcmp(dataType, 'int32')
        verilogType = '32''sb';
        bitWidth = 32;
        matlabType = 'int32';
    else
        error('Unsupported data type: %s', dataType);
    end
    
    % Create a unique name for the parameter in Verilog
    verilogParamName = sprintf('%s_%s', layerName, paramName);
    
    % Write the parameter as a Verilog localparam
    fprintf(fileID, 'localparam [0:%d][%d:0] %s = {', numel(values) - 1, bitWidth - 1, verilogParamName);
    for j = 1:numel(values)
        % Convert to binary with 2's complement representation
        if values(j) < 0
            binaryValue = dec2bin(bitcmp(abs(values(j)) - 1, matlabType), bitWidth);
        else
            binaryValue = dec2bin(values(j), bitWidth);
        end
        if j < numel(values)
            fprintf(fileID, '%s%s, ', verilogType, binaryValue);
        else
            fprintf(fileID, '%s%s};\n', verilogType, binaryValue);
        end
    end
    fprintf(fileID, '\n'); % Add a new line for clarity
end

% Close the file
fclose(fileID);

fprintf('Verilog parameters with binary radix in 2''s complement have been saved to %s\n', outputFile);
end
