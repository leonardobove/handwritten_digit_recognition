module FSM_FW (clk, reset, FW_done, FW_go);

	input clk, MLP_go reset;
	output MLP_done;
	parameter IDLE = 0, WAIT1 = 1, WAIT2 = 2, WAIT3 = 3, OUTPUT = 4;
	
	reg [1:0]Sreg, Snext;
	reg MLP_done;
	
	always @ (posedge clk)
		if (reset) Sreg <= IDLE;
		else Sreg <= Snext;
	
	always @ (*)
		case (Sreg)
			IDLE	:	if (MLP_go == 1'b1) Snext = WAIT1;
						else Snext = IDLE;
			WAIT1	:	Snext = WAIT2;								
			WAIT2	:	if (MLP_done == 1'b1) Snext = WAIT3;
			WAIT3	:	Snext = OUTPUT;
            OUTPUT  :   Snext = IDLE;
			default : 	Snext = IDLE;
		endcase
	
	always @ (Sreg)
		begin
            MLP_done = 1'b0;
			case (Sreg)
				OUTPUT  : MLP_done = 1'b1;
				default : 	MLP_done = 1'b0;
			endcase
		end
endmodule
