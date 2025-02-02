module clk_divisor(input clk_50, output divided_clk);

    parameter COUNTER_SIZE = 3;

    reg [(COUNTER_SIZE-1):0] counter = 0;
    
    always @ (posedge clk_50)
        if (counter == (2**COUNTER_SIZE)-1) counter <= 0;
        else counter <= counter + 1'b1;

    assign divided_clk = counter[COUNTER_SIZE-1];
endmodule