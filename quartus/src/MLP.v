module MLP (
    input clk,
    input reset,
    input signed [8*196-1:0] averaged_pixels,
    output signed [8*10-1:0] output_activations
    );

    //constants
    parameter averaged_pixels_nr = 196;
    parameter resolution = 8;
    parameter HL_neurons = 30;
    parameter OL_neurons = 10;

    // Intermediate signals
    wire signed [resolution*averaged_pixels_nr-1:0] averaged_pixels_w;
    wire signed [resolution*OL_neurons-1:0] output_activations_w;
    wire signed [resolution*HL_neurons-1:0] zeds_HL;
    wire signed [resolution*HL_neurons-1:0] activations_HL;
    wire signed [resolution*OL_neurons-1:0] zeds_OL;
    wire signed [resolution*OL_neurons-1:0] activations_OL;
    wire signed [resolution*HL_neurons*averaged_pixels_nr-1:0] intermediate_weights_HL;
    wire signed [resolution*HL_neurons-1:0] intermediate_biases_HL;
    wire signed [resolution*OL_neurons*HL_neurons-1:0] intermediate_weights_OL;
    wire signed [resolution*OL_neurons-1:0] intermediate_biases_OL;

    // Instantiate the input flip-flops
    dff_nbit #(
        .nbit(averaged_pixels_nr)
    ) dff_input (
        .clk(clk),
        .en(1),
        .reset(reset),
        .di(averaged_pixels),
        .do(averaged_pixels_w)
    );

    // Instantiate the hidden_layer_param
    hidden_layer_param i_hidden_layer_param (
        .weights_HL(intermediate_weights_HL),
        .biases_HL(intermediate_biases_HL)
    );

    // Instantiate the Hidden Layer
    layer #(
        .number_neuron(HL_neurons),
        .input_data_size(averaged_pixels_nr),
        .resolution(resolution)
    ) hidden_layer (
        .clk(clk), 
        .reset(reset), 
        .input_data(pixels),
        .weights(intermediate_weights_HL),
        .biases(intermediate_biases_HL),
        .zed(zeds_HL)
    );

    // Instantiate the Hidden Layer Sigmoid
    sigmoid_layer #(
        .number_neuron(HL_neurons)
    ) sigmoid_layer_HL (
        .zeds(zeds_HL),
        .activations(activations_HL)
    );

    // Instantiate the output_layer_param
    output_layer_param i_output_layer_param (
        .weights_HL(intermediate_weights_OL),
        .biases_HL(intermediate_biases_OL)
    );

    // Instantiate the Output Layer
    layer #(
        .number_neuron(OL_neurons),
        .input_data_size(HL_neurons),
        .resolution(resolution)
    ) output_layer (
        .clk(clk), 
        .reset(reset), 
        .input_data(activations_HL),
        .weights(intermediate_weights_OL),
        .biases(intermediate_biases_OL),
        .zed(zeds_OL)
    );

    // Instantiate the Output Layer Sigmoid
    sigmoid_layer #(
        .number_neuron(OL_neurons)
    ) sigmoid_layer_OL (
        .zeds(zeds_OL),
        .activations(activations_OL)
    );

    assign output_activations_w = activations_OL;

    // Instantiate the output flip-flops
    dff_nbit #(
        .nbit(OL_neurons)
    ) dff_output (
        .clk(clk),
        .en(1),
        .reset(reset),
        .di(output_activations_w),
        .do(output_activations)
    );

endmodule