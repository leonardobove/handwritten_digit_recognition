module pixels_avaraging #(
    parameter resolution = 8
    )(
    input clk,
    input pixel_en,
    input [resolution-1:0] in1,
    input [resolution-1:0] in2,
    input [resolution-1:0] in3,
    input [resolution-1:0] in4,
    output [resolution-1:0] out,
    output  pixel_done
    );
    
    reg [2*resolution-1:0] pixel_out;
    
    always @(*) begin
        if(pixel_en == 1) begin
            pixel_out = (in1+in2+in3+in4)>> 2; //Calculate average
        end
        
    end
    
    assign out = pixel_out[2*resolution-1-:resolution];
    assign pixel_done = (pixel_out==(in1+in2+in3+in4)>> 2)? 1:0;

endmodule