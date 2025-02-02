module dff_nbit #(
    parameter nbit = 1
    )(
        input clk,
        input en,
        input reset,
        input [nbit-1:0] di,
        output reg [nbit-1:0] dout
    );

    always @ (posedge clk) begin
        if (reset)
            dout <= 0;
        else if (en)
            dout <= di;
        else
            dout <= dout;
        end

endmodule