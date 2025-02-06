// Signed multiply-accumulate

module signed_multiply_accumulate #(
	parameter WIDTH_A = 32,
	parameter WIDTH_B = 8,
	parameter WIDTH_OUT = 32
	)(
	input clk, aclr, clken, sload,
	input signed [WIDTH_A-1:0] dataa,
	input signed [WIDTH_B-1:0] datab,
	output reg signed [WIDTH_OUT-1:0] adder_out
	);

	reg	 signed [WIDTH_OUT-1:0] old_result;
	wire signed [WIDTH_OUT-1:0] multa;

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