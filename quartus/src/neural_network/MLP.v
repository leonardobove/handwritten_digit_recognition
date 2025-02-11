// Module: MLP (Multi-Layer Perceptron)
// Description: Implements a simple MLP with a hidden layer and an output layer.
// It processes input features using a fully connected neural network structure.
//
// Inputs:
// - clk: Clock signal
// - reset: Active-high reset signal
// - MLP_go: Start signal to begin computation
// - averaged_pixels: Flattened input feature vector
//
// Outputs:
// - MLP_done: Indicates when computation is complete
// - output_activations: Flattened output activations from the output layer

module MLP #(
    //constants
    parameter averaged_pixels_nr = 196, // Number of input features
    parameter WIDTH = 8, // Bit width for input and weights
    parameter HL_neurons = 32, // Number of neurons in the hidden layer
    parameter OL_neurons = 10 // Number of neurons in the output layer
	)(
    input clk,
    input reset,
    input MLP_go,
    input [WIDTH*averaged_pixels_nr-1:0] averaged_pixels,
    output MLP_done,
    output [5*WIDTH*OL_neurons-1:0] output_activations
    );
      
    // Internal signals
    wire hidden_done;
    wire signed [3*WIDTH*HL_neurons-1:0] hidden_out;
    
    /* Hidden layer */
    hidden_layer #(
        .averaged_pixels_nr(averaged_pixels_nr),
        .WIDTH(WIDTH),
        .HL_neurons(HL_neurons)
	) hidden_layer_i (
        .clk(clk), 
        .hidden_go(MLP_go), 
        .reset(reset), 
        .hidden_in(averaged_pixels), 
        .hidden_out(hidden_out), 
        .hidden_done(hidden_done)
    );

    /* Output layer */
    output_layer #(
        .HL_neurons(HL_neurons),
        .WIDTH(WIDTH),
        .OL_neurons(OL_neurons)
    ) output_layer_i (
        .clk(clk), 
        .output_go(hidden_done), 
        .reset(reset), 
        .output_in(hidden_out), 
        .output_out(output_activations), 
        .output_done(MLP_done)
    );
    
endmodule