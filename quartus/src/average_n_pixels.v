// This module computes the average value between n input pixels
// each with resolution number of bits. n must be a multiple of 2.
// The input values are treated as unsigned. The output value will
// be an unsigned integer with the same resolution as the inputs.
module average_n_pixels #(
    parameter resolution = 8, // Number of bits for each pixel
    parameter n = 4           // Number of input pixels to be averaged. Must be multiple of 2.
)(
    input clk,
    input reset,
    input [resolution*n-1:0] input_pixels,
    output reg [resolution-1:0] out
);

    // Declare sum with enough bits to contain the sum of n integers of resolution bits
    wire [(resolution+$clog2(n))-1:0] sum;
    reg [(resolution+$clog2(n))-1:0] sum_reg;

    integer i;
    always @ (*) begin
        sum_reg = 0;
        for (i = 0; i < n; i = i + 1)
            sum_reg = sum_reg + input_pixels[resolution*i+:resolution];
    end

    assign sum = sum_reg;

	// Clear or update data
	always @ (posedge clk) begin
		if (reset)
			out <= 0;
		else
            out <= sum >> $clog2(n);
	end

endmodule