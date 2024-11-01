module FSM_FW (clk, reset, FW_done, FW_go);
input clk, FW_go, averaging_done, MLP_done, reset;
output FW_done;
parameter IDLE = 0, AVERAGING = 1, MLP = 2;

reg [1:0]Sreg, Snext;
reg FW_done = 0;

always @ (posedge clk)
	if (reset) Sreg <= IDLE;
	else Sreg <= Snext;

always @ (*)
	case (Sreg)
	IDLE		:	if (FW_go == 1'b1) Snext = AVERAGING;
					else	Snext = IDLE;
	AVERAGING	:	if (averaging_done == 1'b1) Snext = MLP;
					else Snext = AVERAGING;
	MLP			:	if (MLP_done == 1'b1) begin
						Snext = IDLE;
						FW_done = 1'b1;
					end else
						Snext = MLP;
	default		: 	Snext = IDLE;
	endcase

always @ (Sreg)
begin
	Go1 = 1'b0;
	Go2 = 1'b0;
	case (Sreg)
	Go_1		:	Go1 = 1'b1;
	Go_2		:	Go2 = 1'b1;
	default	: 	begin
						Go1 = 1'b0;
						Go2 = 1'b0;
					end
	endcase
end
endmodule
