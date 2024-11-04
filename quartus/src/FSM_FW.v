module FSM_FW (clk, reset, FW_done, FW_go);

	input clk, FW_go, AVERAGING_done, MLP_done, PREDICTED_DIGIT_done, reset;
	output FW_done, AVERAGING_go, MLP_go, PREDICTED_DIGIT_go;
	parameter IDLE = 0, AVERAGING = 1, MLP = 2, PREDICTED_DIGIT = 3;
	
	reg [1:0]Sreg, Snext;
	reg FW_done, AVERAGING_go, MLP_go;
	
	always @ (posedge clk)
		if (reset) Sreg <= IDLE;
		else Sreg <= Snext;
	
	always @ (*)
		case (Sreg)
			IDLE			:	if (FW_go == 1'b1) Snext = AVERAGING;
								else Snext = IDLE;
			AVERAGING		:	if (AVERAGING_done == 1'b1) Snext = MLP;
								else Snext = AVERAGING;
			MLP				:	if (MLP_done == 1'b1) Snext = PREDICTED_DIGIT;
								else Snext = MLP;
			PREDICTED_DIGIT	:	if (PREDICTED_DIGIT_done = 1'b1)
									begin 
										Snext = IDLE;
										FW_done = 1'b1;
									end
								else Snext = MLP;
			default		: 	Snext = IDLE;
		endcase
	
	always @ (Sreg)
		begin
			FW_done = 1'b0;
			AVERAGING_go = 1'b0;
			MLP_go = 1'b0;
			PREDICTED_DIGIT_go = 1'b0;
			case (Sreg)
				AVERAGING		:	AVERAGING_go = 1'b1;
				MLP				: 	MLP_go = 1'b1;
				PREDICTED_DIGIT	: 	PREDICTED_DIGIT_go = 1'b1;
				default		: 	begin
									FW_done = 1'b0;
									AVERAGING_go = 1'b0;
									MLP_go = 1'b0;
									PREDICTED_DIGIT_go = 1'b0;
								end
				endcase
		end
endmodule
