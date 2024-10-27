module MLP(
    input clk,
    input reset,
    input signed [7:0] pixels [783:0],
    output signed [7:0] output_activations [9:0]
    );

    //constants
    parameter pixels_number = 784;
    parameter resolution = 8;
    parameter HL_neurons = 30;
    parameter OL_neurons = 10;

    // Intermediate signals
    wire signed [7:0] zeds_HL [29:0];
    wire signed [7:0] activations_HL [29:0];
    wire signed [7:0] zeds_OL [9:0];
    wire signed [7:0] activations_OL [9:0];
    wire signed [7:0] intermediate_weights_HL [29:0][783:0];
    wire signed [7:0] intermediate_biases_HL [29:0];
    wire signed [7:0] intermediate_weights_OL [9:0][29:0];
    wire signed [7:0] intermediate_biases_OL [9:0];

    // Instantiate the hidden_layer_param
    hidden_layer_param i_hidden_layer_param (
        .weights_HL(intermediate_weights_HL),
        .biases_HL(intermediate_biases_HL)
    );

    // Instantiate the Hidden Layer
    layer #(
        .number_neuron(HL_neurons),
        .input_data_size(pixels_number),
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
    ooutput_layer_param i_output_layer_param (
        .weights_HL(intermediate_weights_OL),
        .biases_HL(intermediate_biases_OL)
    );

    // Instantiate the Output Layer
    layer #(
        .number_neuron(OL_neurons),
        .input_data_size(HL_neurons),
        .resolution(resolution)
    ) hidden_layer (
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

    assign output_activations = activations_OL;

endmodule