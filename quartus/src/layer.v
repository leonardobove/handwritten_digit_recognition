module layer #(
    parameter number_neuron = 30,
    parameter input_data_size = 784,
    parameter resolution = 8
) (
    input clk,
    input reset,
    input signed [resolution-1:0] input_data[input_data_size-1:0],
    input signed [resolution-1:0] weights[number_neuron-1:0][input_data_size-1:0],
    input signed [resolution-1:0] biases[number_neuron-1:0],
    output signed [resolution-1:0] zed[number_neuron-1:0]
);

    // Generate block for creating each neuron instance
    genvar i;
    generate
        for (i = 0; i < number_neuron; i = i + 1) begin : neuron_array
            neuron #(
                .input_data_size(input_data_size),
                .resolution(resolution)
            ) neuron_inst (
                .clk(clk), 
                .reset(reset), 
                .input_data(input_data),
                .weight(weights[i]),
                .bias(biases[i]),
                .zed(output_neuron[i])
            );
        end
    endgenerate

endmodule
