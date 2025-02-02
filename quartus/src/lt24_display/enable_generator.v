/*
 * This module generates a high enable signal for one input clock cycle
 * every 2^(COUNTER_SIZE) input clock cycles.
 * This allows to implement functional clock gating for modules that need
 * to be clocked at slower frequencies.
 */

module enable_generator #(
    parameter COUNTER_SIZE = 3
)(
    input input_clock,
    output output_enable
);
    reg [(COUNTER_SIZE-1):0] counter = 0;
    
    always @ (posedge input_clock)
        if (counter == (2**COUNTER_SIZE)-1) counter <= 0;
        else counter <= counter + 1'b1;

    assign output_enable = (counter == (2**COUNTER_SIZE)-1);
endmodule