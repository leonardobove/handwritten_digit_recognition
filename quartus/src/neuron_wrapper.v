module neuron_wrapper #(
    parameter input_data_size = 1,
    parameter resolution = 8
)(
    input clk,
    input reset,
    input signed [resolution*input_data_size-1:0] input_data,
    input signed [resolution*input_data_size-1:0] weight,
    input signed [resolution-1:0] bias,
    output signed [resolution-1:0] output_neuron
);

    wire signed [resolution*input_data_size-1:0] input_data_w;

    // Instantiate dff_nbit for pixel data storage
    dff_nbit #(resolution*input_data_size) dff_in (
        .clk(clk),
        .reset(reset),
        .en(1'b1),
        .di(input_data),
        .dout(input_data_w)
    );

    // Instantiate the neuron module
    neuron #(
        .input_data_size(input_data_size),
        .resolution(resolution)
    ) i_neuron (
        .clk(clk),
        .reset(reset),
        .input_data(input_data_w),
        .weight(weight),
        .bias(bias),
        .output_neuron(output_neuron)
    );


endmodule