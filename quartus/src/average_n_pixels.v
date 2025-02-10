// This module computes the average value between n input pixels
// each with a single bit. n must be a power of 2.
// The output value will be a signed integer with the given resolution.
module average_n_pixels #(
    parameter output_resolution = 8, // Number of bits for each output pixel
    parameter n = 4                  // Number of input pixels to be averaged. Must be multiple of 2.
)(
    input clk,
    input reset,
    input [n-1:0] input_pixels,
    output [output_resolution-1:0] out
);

   // Declare sum with enough bits to contain the sum of n integers of resolution bits
   reg [1+$clog2(n):0] sum;

   integer i;
   always @ (*) begin
       sum = 0;
       for (i = 0; i < n; i = i + 1)
           sum = sum + input_pixels[i +: 1];
   end

	// Temporary registred output for calculations
	reg [$clog2(n)+output_resolution-1:0] out_temp;
   
	// Clear or update data
	always @ (posedge clk) begin
		if (reset)
			out_temp <= 0;
		else
         out_temp <= (sum * ((1'b1<<(output_resolution - 1'b1)) - 1'b1)) >> $clog2(n);
	end
	
	// Assign only output_resolution LSBs to out
	assign out = out_temp[output_resolution-1:0];

endmodule