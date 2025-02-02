module layer #(
    parameter number_neuron = 10,
    parameter input_data_size = 196,
    parameter resolution = 8,
    parameter input_data_size_width = ($clog2(input_data_size))
) (
    input clk,
    input reset,
    input neuron_go,
    input [resolution*input_data_size-1:0] input_data, // Flattened 1D input_data
    input [resolution*input_data_size*number_neuron-1:0] weights, // Flattened weights for all neurons
    input [resolution*number_neuron-1:0] biases, // Flattened biases for all neurons
    output layer_done,
    output [resolution*number_neuron-1:0] zed // Flattened outputs for all neurons
);

    wire [number_neuron-1:0] layer_done_tot;

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
                .neuron_go(neuron_go), 
                .input_data(input_data), // Flattened input data
                .weight(weights[(i+1)*input_data_size*resolution-1 -: input_data_size*resolution]), // Slice for each neuron
                .bias(biases[(i+1)*resolution-1 -: resolution]), // Select bias for this neuron
                .neuron_done(layer_done_tot[i]),
                .output_neuron(zed[(i+1)*resolution-1 -: resolution]) // Output from this neuron
            );
        end
    endgenerate

    assign layer_done = layer_done_tot[0]; //the first one for example

endmodule
