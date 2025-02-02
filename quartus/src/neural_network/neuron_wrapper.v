module neuron_wrapper #(
    parameter input_data_size = 1,
    parameter input_data_size_width = ($clog2(input_data_size)),
    parameter resolution = 8
)(
    input clk,
    input reset,
    input start,
    input signed [resolution*input_data_size-1:0] input_data,
    input signed [resolution*input_data_size-1:0] weight,
    input signed [resolution-1:0] bias,
    output [resolution-1:0] output_neuron
);

    // Instantiate the neuron module
    neuron #(
        .input_data_size(input_data_size),
        .resolution(resolution)
    ) i_neuron (
        .clk(clk),
        .reset(reset),
        .neuron_go(start),
        .input_data(input_data),
        .weight(weight),
        .bias(bias),
        .output_neuron(output_neuron)
    );


endmodule