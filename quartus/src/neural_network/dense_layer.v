// This module is a dense layer for the MLP. 
// It generates neuron instantiations and produces the computed neuron activations as outputs, 
// along with a done signal that is set to 1 when all neurons have completed their computations. 
// The module has different width parameters since the input data length varies between layers, 
// while the output remains 32 bits. The weights and biases maintain an 8-bit precision.

module dense_layer # (
    parameter NEURON_NB = 32, // Number of neurons in the dense layer
    parameter IN_SIZE = 196, // Number of input features per neuron
    parameter WIDTH = 8, // Bit width for weights and biases
    parameter WIDTH_IN = 8, // Bit width of the input data
    parameter WIDTH_OUT = 32 // Bit width of the output data
    )(
    input clk,
    input dense_go, // Start signal for computation
    input reset,
    input signed [WIDTH_IN*IN_SIZE-1:0] dense_in, // Flattened input data array
    input signed [WIDTH*NEURON_NB*IN_SIZE-1:0] weights,
    input signed [WIDTH*NEURON_NB-1:0] biases,
    output signed [WIDTH_OUT*NEURON_NB-1:0] dense_out, // Output activations
    output dense_done // Signal indicating completion of computation
    );
    
    wire [NEURON_NB-1:0] neuron_done;

    // Generate block for creating each neuron instance
    genvar i;
    generate
        for (i = 0; i < NEURON_NB; i = i + 1) begin : neuron_array
            neuron #(
                .IN_SIZE(IN_SIZE),
                .WIDTH(WIDTH),
                .WIDTH_IN(WIDTH_IN),
                .WIDTH_OUT(WIDTH_OUT)
            ) neuron_inst (
                .clk(clk),  
                .reset(reset), 
                .neuron_go(dense_go),
                .in_data(dense_in), // Flattened input data
                .weight(weights[(i+1)*IN_SIZE*WIDTH-1 -: IN_SIZE*WIDTH]), // Slice for each neuron
                .bias(biases[(i+1)*WIDTH-1 -: WIDTH]), // Select bias for this neuron
                .output_neuron(dense_out[(i+1)*WIDTH_OUT-1 -: WIDTH_OUT]), // Output from this neuron
                .neuron_done(neuron_done[i])
            );
        end
    endgenerate

    // All neurons must complete for dense layer to be done
    assign dense_done = ((neuron_done & (2**NEURON_NB - 1'b1)) == 2**NEURON_NB - 1'b1);

endmodule
