module FW_logic (
    input clk,
    input reset,
    input [784*8-1:0] pixels, // For example, 784*8 input pixels
    input en,
    output [3:0] predicted_digit
);

    // Internal signals
    wire [784*8-1:0] pixel_data;  // Internal wire for pixel data
    wire [196*8-1:0] averaged_pixels;
    wire [196*8-1:0] averaged_pixels_data;
    wire [10*8-1:0] activated_pixels;
    wire [10*8-1:0] activated_pixels_data;
    wire [3:0] predicted_digit_w;

    // Instantiate dff_nbit for pixel data storage
    dff_nbit #(784*8) dff_in (
        .clk(clk),
        .reset(reset),
        .en(en),
        .di(pixels),
        .dout(pixel_data)
    );

    // Instantiate the average_pooling block
    average_pooling #(
        .resolution(8),
        .pixels_number(784),
        .averaged_pixels_nr(196)
    ) avg_pool (
        .pixels(pixel_data),
        .pixels_averaged(averaged_pixels)
    );

    // Instantiate dff_nbit for pixel data storage
    dff_nbit #(196*8) dff_averaged (
        .clk(clk),
        .reset(reset),
        .en(en),
        .di(averaged_pixels),
        .dout(averaged_pixels_data)
    );

    // MLP block for predictions
    MLP #(
        .averaged_pixels_nr(196),
        .resolution(8),
        .HL_neurons(30),
        .OL_neurons(10)
    ) mlp (
        .clk(clk),
        .reset(reset),
        .averaged_pixels(averaged_pixels),
        .output_activations(activated_pixels)
    );

    // D flip-flops for activated data
    dff_nbit #(10*8) dff_activation (
        .clk(clk),
        .reset(reset),
        .en(en),
        .di(activated_pixels),
        .dout(activated_pixels_data)
    );

    // Predicted digit block
    predicted_digit #(
        .neuron_number(10),
        .resolution(8)
    ) i_predicted_digit (
        .output_activations(activated_pixels_data),
        .predicted_digit(predicted_digit_w)
    );

    // D flip-flops for output data
    dff_nbit #(4) dff_out (
        .clk(clk),
        .reset(reset),
        .en(en),
        .di(predicted_digit_w),
        .dout(predicted_digit)
    );

endmodule