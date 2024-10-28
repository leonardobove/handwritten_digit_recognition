module hidden_layer_param (
    output reg signed [8*30*784-1:0] weights_HL, // Declare output as a flattened 1D array for weights
    output reg signed [8*30-1:0] biases_HL // Declare output as a flattened 1D array for biases
);

    // Local parameters for initialized weights and biases
    localparam signed [7:0] weights_HL_param [29:0][783:0] = '{default: '{default: 8'sd0}}; // Initialize weights to zero
    localparam signed [7:0] biases_HL_param [29:0] = '{default: '{default: 8'sd0}}; // Initialize biases to zero

    // Assign values to weights and biases
    always @(*) begin
        integer i, j;

        // Assign weights from the localparam to the output
        for (i = 0; i < 30; i = i + 1) begin
            for (j = 0; j < 784; j = j + 1) begin
                // Flattened access
                weights_HL[(i * 784 + j) * 8 +: 8] = weights_HL_param[i][j]; // Assign 8 bits for each weight
            end
            biases_HL[i * 8 +: 8] = biases_HL_param[i]; // Assign 8 bits for each bias
        end
    end

endmodule

