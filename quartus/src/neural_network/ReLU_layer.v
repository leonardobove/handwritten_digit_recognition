module ReLU_layer #(
    parameter NEURON_NB = 10,
    parameter IN_SIZE = 196,   
    parameter WIDTH = 32
) (
    input clk,
    input reset,
    input relu_go,
    input [WIDTH*NEURON_NB-1:0] data_in_array, // Flattened 1D array for inputs
    output relu_layer_done,
    output [WIDTH*NEURON_NB-1:0] data_out_array // Flattened 1D array for outputs (unsigned)
);

    wire [NEURON_NB-1:0] relu_done;

    // Instantiate the Sigmoid Activation Function for each neuron in the hidden layer
    genvar i;
    generate
        for (i = 0; i < NEURON_NB; i = i + 1) begin: ReLU_units
            // Sigmoid instance
            ReLU #(
                .IN_SIZE(IN_SIZE),
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

    assign relu_layer_done = ((relu_done & (2**NEURON_NB - 1'b1)) == 2**NEURON_NB - 1'b1);

endmodule