module pixels_avaraging(
    input clk,
    input pool_en,
    input [7:0] in1,
    input [7:0] in2,
    input [7:0] in3,
    input [7:0] in4,
    output [7:0] out,
    output  pool_done
    );
    
    reg [15:0] pool_out;
    
    always @(*) begin
        if(pool_en == 1) begin
            pool_out = (in1+in2+in3+in4)>> 2; //Calculate average
        end
        
    end
    
    assign out = pool_out[7:0];
    assign pool_done = (pool_out==(in1+in2+in3+in4)>> 2)? 1:0;

endmodule