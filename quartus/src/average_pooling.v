module average_pooling #(
    parameter resolution = 8,
    parameter pixels_number = 16,
    parameter averaged_pixels_nr = 4
    )(
    input [resolution*pixels_number-1:0] pixels,
    output [resolution*averaged_pixels_nr-1:0] pixels_averaged
    );

    //parameters
    parameter pixels_address_nr = ($clog2(pixels_number));
    parameter averaged_pixels_address_nr = ($clog2(averaged_pixels_nr));

    // Generate parallel instances of average4
    genvar r, c;
    generate
        for (r = 0; r < ((pixels_address_nr >> 1) - 1); r = r + 1) begin : row_loop
            for (c = 0; c < ((pixels_address_nr >> 1) - 1); c = c + 1) begin : col_loop
            // Calculate the starting index of the 2x2 block
            localparam integer idx = (r * 2 * pixels_address_nr) + (c * 2);
            pixels_averaging #(
                .resolution(resolution)
            )avg_inst (
                .in1(pixels[idx*resolution+:resolution]),                // Top-left pixel
                .in2(pixels[(idx + 1)*resolution+:resolution]),            // Top-right pixel
                .in3(pixels[(idx + pixels_address_nr)*resolution+:resolution]),  // Bottom-left pixel
                .in4(pixels[(idx + pixels_address_nr + 1)*resolution+:resolution]), // Bottom-right pixel
                .out(pixels_averaged[(r * averaged_pixels_address_nr + c)*resolution+:resolution]) // Output position for averaged result
             );
            end
        end
    endgenerate

endmodule