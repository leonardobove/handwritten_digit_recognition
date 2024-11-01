module MLP_pooling (
    input clk,
    input reset,
    input [resolution*pixels_number-1:0] pixels,
    output [8*10-1:0] output_activations 
    );

    parameter resolution = 8;
    parameter pixels_number = 784;
    parameter averaged_pixels_nr = 196;   

    pooling #(
        .resolution(resolution),
        .averaged_pixels_nr(averaged_pixels_nr)
    ) i_pooling(
        .reset(reset),
        .pixels(pixels),
        .pool(pool)
    );

    MLP #(
        .averaged_pixels_nr(averaged_pixels_nr),
        .resolution(resolution)
    ) i_MLP(
        .clk(clk),
        .reset(reset),
        .pixels(pool),
        .output_activations(output_activations)
    );

endmodule