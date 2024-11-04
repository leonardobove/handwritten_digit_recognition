module FSM_FW (clk, reset, FW_done, FW_go);

	input clk, FW_go, MLP_done, reset;
	output FW_done, MLP_go;
	parameter IDLE = 0, AVERAGING = 1, MLP = 2, PREDICTED_DIGIT = 3;
	
	reg [1:0]Sreg, Snext;
	reg FW_done, MLP_go;
	
	always @ (posedge clk)
		if (reset) Sreg <= IDLE;
		else Sreg <= Snext;
	
	always @ (*)
		case (Sreg)
			IDLE			:	if (FW_go == 1'b1) Snext = AVERAGING;
								else Snext = IDLE;
			AVERAGING		:	Snext = MLP;								
			MLP				:	if (MLP_done == 1'b1) Snext = PREDICTED_DIGIT;
								else Snext = MLP;
			PREDICTED_DIGIT	:	Snext = IDLE;
			default			: 	Snext = IDLE;
		endcase
	
	always @ (Sreg)
		begin
			FW_done = 1'b0;
			MLP_go = 1'b0;
			case (Sreg)
				MLP				: 	MLP_go = 1'b1;
				PREDICTED_DIGIT	: 	FW_done = 1'b1;
				default		: 	begin
									FW_done = 1'b0;
									MLP_go = 1'b0;
								end
				endcase
		end
endmodule
