module sigmoid_layer #(
    parameter number_neuron = 30,
    parameter resolution = 8 // Add resolution parameter
) (
    input signed [resolution*number_neuron-1:0] zeds, // Flattened 1D array for inputs
    output signed [resolution*number_neuron-1:0] activations // Flattened 1D array for outputs
);

    // Instantiate the Sigmoid Activation Function for each neuron in the hidden layer
    genvar i;
    generate
        for (i = 0; i < number_neuron; i = i + 1) begin: sigmoid_units
            // Sigmoid instance
            sigmoid sigmoid_HL (
                .zed(zeds[(i+1)*resolution-1 -: resolution]), // Unpacking input for each neuron
                .activation(activations[(i+1)*resolution-1 -: resolution]) // Unpacking output for each neuron
            );
        end
    endgenerate

endmodule
