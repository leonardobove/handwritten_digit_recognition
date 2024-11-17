module counter #(
    parameter MAX_VALUE = 15
)(
    input clk,
    input en,
    input reset,
    output reg [$clog2(MAX_VALUE)-1:0] count
);

always @ (posedge clk)
    if (reset)
        count <= 1'b0;
    else if (en) begin
        count <= count + 1'b1;
        if (count == (MAX_VALUE-1))
            count <= 1'b0;
    end

endmodule