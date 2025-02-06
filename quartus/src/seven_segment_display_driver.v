/*  This module drives the first of the six seven segment displays (with decimal point DP)
 *  available on the DE10-lite board. The LEDs of the segments are connected
 *  in a common-anode configuration. The segment is turned on by applying a 
 *  low logic level on the corresponding output.
 */

module seven_segment_display_driver(
    input [3:0] digit,         // 4-bit input representing the digit (0 to 9)
    output reg [7:0] seg       // 7-segment display output (a, b, c, d, e, f, g, DP)
);

    always @(*) begin
        case (digit)
            4'd0: seg = 8'b00000011; // 0
            4'd1: seg = 8'b10011111; // 1
            4'd2: seg = 8'b00100101; // 2
            4'd3: seg = 8'b00001101; // 3
            4'd4: seg = 8'b10011001; // 4
            4'd5: seg = 8'b01001001; // 5
            4'd6: seg = 8'b01000001; // 6
            4'd7: seg = 8'b00011111; // 7
            4'd8: seg = 8'b00000001; // 8
            4'd9: seg = 8'b00011001; // 9
            default: seg = 8'b11111110; // Default case (decimal point on)
        endcase
    end

endmodule
