/**********
* Neural Network implementation
*
* Inputs: clk => clock signal, enable => NN enable signal, img => in vector, 
*
* Outputs: digit out => handwritten digit
*          MLP_done => done signal
* 
***********/
module MLP #(
    //constants
    parameter averaged_pixels_nr = 196,
    parameter WIDTH = 8,
    parameter HL_neurons = 32,
    parameter OL_neurons = 10
	)(
    input clk,
    input reset,
    input MLP_go,
    input [WIDTH*averaged_pixels_nr-1:0] averaged_pixels,
    output MLP_done,
    output [4*WIDTH*OL_neurons-1:0] output_activations
    );
      
    wire hidden_done;
    wire signed [4*WIDTH*HL_neurons-1:0] hidden_out;
    
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