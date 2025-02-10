// Module: ReLU (Rectified Linear Unit)
// Description: Implements the ReLU activation function: max(0, data_in).
// When `relu_go` is asserted, the module processes `data_in` and sets `data_out`.
// The `relu_done` flag indicates completion.
module ReLU #( 
    parameter WIDTH = 32
)(
    input clk,                       // Clock input
    input reset,                     // Active high reset
    input signed [WIDTH-1:0] data_in,
    input relu_go,
    output reg [WIDTH-1:0] data_out,
    output reg relu_done
);

    // Declare temp as signed to handle signed input correctly
    wire signed [WIDTH-1:0] temp;

    // Apply ReLU: If data_in > 0, keep data_in; otherwise, set to 0
    assign temp = (data_in > 0) ? data_in : 0;

    // Sequential block to control output data_out based on the clock
    always @(posedge clk) begin
        if (reset) begin
            data_out <= 0; // Reset condition
            relu_done <= 0;
        end else begin
            if (relu_go)
                data_out <= temp;
            relu_done <= relu_go;
        end
    end

endmodule
