module output_layer_param (
    output reg signed [8*10*30-1:0] weights_HL, // Declare output as a flattened 1D array for weights
    output reg signed [8*10-1:0] biases_HL // Declare output as a flattened 1D array for biases
);

    // Local parameters for initialized weights and biases
    localparam signed [8*10*30-1:0] weights_HL_param = 0;
    
    localparam signed [8*10-1:0] biases_HL_param = 0;

    // Assign weights from the localparam to the output
    always @(*) begin
        integer i, j;
        // Assign weights from the flattened localparam to the output
        for (i = 0; i < 10; i = i + 1) begin
            for (j = 0; j < 30; j = j + 1) begin
                weights_HL[(i * 30 + j) * 8 +: 8] = weights_HL_param[i * 30 + j];
            end
            biases_HL[i * 8 +: 8] = biases_HL_param[i];
        end
    end

endmodule
