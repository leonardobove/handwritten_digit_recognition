module dff_nbit #(
    parameter nbit = 1
    )(
        input clk,
        input en,
        input reset,
        input signed [nbit-1:0] di,
        output signed reg [nbit-1:0] do
    );

    always @ (posedge clk) begin
        if (reset)
            do <= 0;
        else if (en)
            do <= di;
        else
            do <= do;
        end

endmodule