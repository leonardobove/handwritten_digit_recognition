/**********
* Dense dense implementation
*
* Parameters: NEURON_NB => The # of neurons
*             IN_SIZE => The input vector size
*             WIDTH => The width of the weights and biases
*
* Inputs: clk => clock signal, dense_en => enable signal, 
*         reset => active high sync reset signal, in_data => in vector, 
*         weights => neurons weights, biases => neurons biases
*
* Outputs: neuron_out => dense dense output
*          dense_done => done signal
* 
***********/

module dense_layer # (
    parameter NEURON_NB=32, 
    parameter IN_SIZE=196, 
    parameter WIDTH=8,
    parameter WIDTH_IN=8,
    parameter WIDTH_OUT=32
    )(
    input clk,
    input dense_go,
    input reset,
    input signed [WIDTH_IN*IN_SIZE-1:0] dense_in,
    input signed [WIDTH*NEURON_NB*IN_SIZE-1:0] weights,
    input signed [WIDTH*NEURON_NB-1:0] biases,
    output signed [WIDTH_OUT*NEURON_NB-1:0] dense_out,
    output dense_done
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

    assign dense_done = ((neuron_done & (2**NEURON_NB - 1'b1)) == 2**NEURON_NB - 1'b1);

endmodule
