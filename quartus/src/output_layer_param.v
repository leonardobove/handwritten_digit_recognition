module output_layer_param (
    output reg signed [7:0] weights_HL [9:0][29:0], // Declare output as a register array
    output reg signed [7:0] biases_HL [9:0]
);

    localparam signed [7:0] weights_HL_param [9:0][29:0] = '{default: '{default: 8'sd0}}; // Initialize to zero
    localparam signed [7:0] biases_HL_param [9:0] = '{default: '{default: 8'sd0}}; // Initialize to zero

    // Optional: You may want to copy values from weights_array_L2 to output_data
    always @ (*) begin
        integer i, j;
        for (i = 0; i < 10; i = i + 1) begin
            for (j = 0; j < 30; j = j + 1) begin
                weights_HL[i][j] = weights_HL_param[i][j]; // Assign values from weights_array_L2
            end
            biases_HL[i] = biases_HL_param[i];
        end
    end
    
endmodule
