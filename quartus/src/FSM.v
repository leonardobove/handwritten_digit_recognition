module FSM (clk, D1, D2, Start, Go1, Go2, reset);
input clk, D1, D2, Start, reset;
output Go1, Go2;
parameter S0 = 0, Wait_1 = 1, Wait_2 = 2, Go_1 = 3, Done_1 = 4, Go_2 = 5, Done_2 = 6;

reg [4:0]Sreg, Snext;
reg Go1, Go2;

always @ (posedge clk)
if (reset) Sreg <= S0;
else Sreg <= Snext;

always @ (Sreg or Start or D1 or D2)
	case (Sreg)
	S0			:	if (Start == 1'b1) Snext = Wait_1;
					else	Snext = S0;
	Wait_1	:	Snext = Wait_2;
	Wait_2	:	Snext = Go_1;
	Go_1		:	Snext = Done_1;
	Done_1	:	if	(D1 == 1'b0)	Snext = Done_1;
					else
						begin
						if (Start == 1'b1) Snext = Wait_1;
						else Snext = Go_2;
						end
	Go_2		:	Snext = Done_2;
	Done_2	:	if	(D2 == 1'b0) Snext = Done_2;
					else	Snext = S0;
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
