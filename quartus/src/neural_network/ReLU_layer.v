// Module: ReLU_layer
// Description: Implements a layer of ReLU activation functions for `NEURON_NB` neurons.
// The input `data_in_array` is a flattened array containing multiple neuron inputs, 
// and the output `data_out_array` contains the corresponding ReLU-activated values.
//
// When `relu_go` is asserted, all neurons process their inputs in parallel.
// The `relu_layer_done` flag indicates when all activations are complete.
module ReLU_layer #(
    parameter NEURON_NB = 10,  
    parameter WIDTH = 32
) (
    input clk,
    input reset,
    input relu_go,
    input [WIDTH*NEURON_NB-1:0] data_in_array, // Flattened 1D array for inputs
    output relu_layer_done,
    output [WIDTH*NEURON_NB-1:0] data_out_array // Flattened 1D array for outputs (unsigned)
);

    // Flags indicating completion of each ReLU unit
    wire [NEURON_NB-1:0] relu_done;

    // Generate ReLU instances for each neuron
    genvar i;
    generate
        for (i = 0; i < NEURON_NB; i = i + 1) begin: ReLU_units
            // Sigmoid instance
            ReLU #(
                .WIDTH(WIDTH)
            ) i_ReLU (
                .clk(clk),
                .reset(reset),
                .relu_go(relu_go),
                .data_in(data_in_array[(i+1)*WIDTH-1 -: WIDTH]), // Unpacking input for each neuron
                .data_out(data_out_array[(i+1)*WIDTH-1 -: WIDTH]), // Unpacking output for each neuron
                .relu_done(relu_done[i])
            );
        end
    endgenerate

    // Check if all ReLU units are done
    assign relu_layer_done = ((relu_done & (2**NEURON_NB - 1'b1)) == 2**NEURON_NB - 1'b1);

endmodule