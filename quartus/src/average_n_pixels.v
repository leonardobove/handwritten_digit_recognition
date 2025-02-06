// This module computes the average value between n input pixels
// each with a given number of bits. n must be a multiple of 2.
// The input values are treated as unsigned. The output value will
// be an unsigned integer with another given resolution.
module average_n_pixels #(
    parameter input_resolution = 1,  // Number of bits for each input pixel
    parameter output_resolution = 8, // Number of bits for each output pixel
    parameter n = 4                  // Number of input pixels to be averaged. Must be multiple of 2.
)(
    input clk,
    input reset,
    input [input_resolution*n-1:0] input_pixels,
    output reg [output_resolution-1:0] out
);

    // Declare sum with enough bits to contain the sum of n integers of resolution bits
    reg [(output_resolution+$clog2(n))-1:0] sum;

    integer i;
    always @ (*) begin
        sum = 0;
        for (i = 0; i < n; i = i + 1)
            sum = sum + input_pixels[input_resolution*i+:input_resolution];
    end

	// Clear or update data
	always @ (posedge clk) begin
		if (reset)
			out <= 0;
		else
            out <= (sum * (2**output_resolution - 1'b1)) >> $clog2(n);
	end

endmodule