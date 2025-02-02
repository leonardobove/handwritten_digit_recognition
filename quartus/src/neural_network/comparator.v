module comparator #(
    parameter resolution = 8,    // Width of each input value
    parameter index_size = 4     // Width of the index
)(
    input clk,
    input reset,
    input [resolution-1:0] in1,  // First input value
    input [resolution-1:0] in2,  // Second input value
    input [index_size-1:0] idx1, // Index associated with in1
    input [index_size-1:0] idx2, // Index associated with in2
    output reg [resolution-1:0] max_val, // Maximum value
    output reg [index_size-1:0] max_idx  // Index of the maximum value
);

    always @(posedge clk)
        if (reset) begin
            max_val <= 0;
            max_idx <= 0;
        end else begin
            if (in1 >= in2) begin 
                max_val <= in1;
                max_idx <= idx1;
            end else begin
                max_val <= in2;
                max_idx <= idx2;
            end
        end
    //assign {max_val, max_idx} = (in1 >= in2) ? {in1, idx1} : {in2, idx2};

endmodule