module sigmoid_layer #(
    parameter number_neuron = 30
) (
    input signed [resolution-1:0] zeds[number_neuron-1:0];
    output signed [resolution-1:0] activations[number_neuron-1:0]
);

    // Instantiate the Sigmoid Activation Function for each neuron in the hidden layer
    genvar i;
    generate
        for (i = 0; i < number_neuron; i = i + 1) begin: sigmoid_units
            sigmoid sigmoid_HL (
                .zed(zeds[i]),
                .activation(activations[i])
            );
        end
    endgenerate

endmodule