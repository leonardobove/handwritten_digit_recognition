// Signed multiply-accumulate

module signed_multiply_accumulate
#(parameter WIDTH=8, input_data_size = 1)
(
	input clk, aclr, clken, sload,
	input signed [WIDTH-1:0] dataa,
	input signed [WIDTH-1:0] datab,
	output reg signed [2*WIDTH+$clog2(input_data_size):0] adder_out
);

	reg	 signed [2*WIDTH+$clog2(input_data_size):0] old_result;
	wire signed [2*WIDTH-1:0] multa;

	// Store the results of the operations on the current data
	assign multa = dataa * datab;

	// Store (or clear) old results
	always @ (adder_out, sload)
	begin
		if (sload)
			old_result <= 0;
		else
			old_result <= adder_out;
	end

	// Clear or update data, as appropriate
	always @ (posedge clk)
	begin
		if (aclr)
			adder_out <= 0;
		else if (clken)
			adder_out <= old_result + multa;
	end
endmodule