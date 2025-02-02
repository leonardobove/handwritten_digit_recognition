module average_pooling #(
    //parameters
    parameter resolution = 8,
    parameter pixels_number = 784,
    parameter averaged_pixels_nr = 196,
    parameter pixels_address_nr = ($clog2(pixels_number)),
    parameter averaged_pixels_address_nr = ($clog2(averaged_pixels_nr))
    )(
    input clk,
    input reset,
    input [resolution*pixels_number-1:0] pixels,
    output [resolution*averaged_pixels_nr-1:0] pixels_averaged
    );

    // Generate parallel instances of average4
    genvar r, c;
    generate
        for (r = 0; r < (28 >> 1); r = r + 1) begin : row_loop //ONLY FOR 784 PIXELS
            for (c = 0; c < (28 >> 1); c = c + 1) begin : col_loop
            // Calculate the starting index of the 2x2 block
            localparam integer idx = (r * 2 * 28) + (c * 2);
            pixels_averaging #(
                .resolution(resolution)
            )avg_inst (
                .clk(clk),
                .reset(reset),
                .in1(pixels[idx*resolution+:resolution]),                // Top-left pixel
                .in2(pixels[(idx + 1)*resolution+:resolution]),            // Top-right pixel
                .in3(pixels[(idx + 28)*resolution+:resolution]),  // Bottom-left pixel
                .in4(pixels[(idx + 28 + 1)*resolution+:resolution]), // Bottom-right pixel
                .out(pixels_averaged[(r * 14 + c)*resolution+:resolution]) // Output position for averaged result
             );
            end
        end
    endgenerate

endmodule