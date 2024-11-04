module pixels_averaging #(
    parameter resolution = 8
    )(
    input [resolution-1:0] in1,
    input [resolution-1:0] in2,
    input [resolution-1:0] in3,
    input [resolution-1:0] in4,
    output [resolution-1:0] out
    );
    
    assign out = (in1+in2+in3+in4)>> 2;

endmodule