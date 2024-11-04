module average_pooling_wrapper #(
    // Parameters
    parameter resolution = 8,
    parameter pixels_number = 16,
    parameter averaged_pixels_nr = 4
    ) (
    input clk,
    input [resolution*pixels_number-1:0] pixels,
    output[resolution*averaged_pixels_nr-1:0] pixels_averaged
    );

    wire [resolution*pixels_number-1:0] pixels_w;
    wire [resolution*averaged_pixels_nr-1:0] pixels_averaged_w;

    dff_nbit #(
        .nbit(pixels_number*resolution)
    ) dff_input (
        .clk(clk),
        .en(1'b1),
        .reset(1'b0),
        .di(pixels),
        .do(pixels_w)
    );

    // Instantiate the DUT (Device Under Test)
    average_pooling #(
        .resolution(resolution),
        .pixels_number(pixels_number),
        .averaged_pixels_nr(averaged_pixels_nr)
    ) dut (
        .pixels(pixels_w),
        .pixels_averaged(pixels_averaged_w)
    );

    dff_nbit #(
        .nbit(averaged_pixels_nr*resolution)
    ) dff_output (
        .clk(clk),
        .en(1'b1),
        .reset(1'b0),
        .di(pixels_averaged_w),
        .do(pixels_averaged)
    );

endmodule
