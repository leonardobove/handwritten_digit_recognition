module pixels_averaging #(
    parameter resolution = 8
    )(
    input clk,
    input reset,
    input [resolution-1:0] in1,
    input [resolution-1:0] in2,
    input [resolution-1:0] in3,
    input [resolution-1:0] in4,
    output reg [resolution-1:0] out
    );

    wire [2*resolution-1:0] sum;

    assign sum = in1 + in2 + in3 + in4;

	// Clear or update data, as appropriate
	always @ (posedge clk)
	begin
		if (reset)
			out <= 0;
		else
            out <= sum >> 2;
	end

endmodule