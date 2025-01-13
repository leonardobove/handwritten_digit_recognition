`timescale 1ns/1ps
module lt24_touchscreen_driver_tb();
    // LT24 touchscreen driver interface
    reg clk = 0;
    reg en = 0;
    reg reset = 0;
    
    wire pos_ready;
    wire [11:0] x_pos, y_pos;

    // AD7843 interface
    reg adc_penirq_n = 1;
    reg adc_dout = 0;
    reg adc_busy = 0;

    wire adc_din, adc_dclk, adc_cs_n;

    lt24_touchscreen_driver dut (
        .clk(clk),
        .en(en),
        .reset(reset),
        .pos_ready(pos_ready),
        .x_pos(x_pos),
        .y_pos(y_pos),
        .adc_penirq_n(adc_penirq_n),
        .adc_busy(adc_busy),
        .adc_cs_n(adc_cs_n),
        .adc_dclk(adc_dclk),
        .adc_din(adc_din),
        .adc_dout(adc_dout)
    );

    always begin
        #5 clk = ~clk;
    end

    // Enable generation
    always begin
        #30 en = 1'b1;
        #10 en = 1'b0;
    end

    localparam x = 12'b101010101010;
    localparam y = 12'b010101010101;

    integer i;

    initial begin
        #20;
        reset = 1;
        #40;
        reset = 0;
        #40;

        adc_penirq_n = 0;
        #80;
        adc_penirq_n = 1;
        
        #(80*7);
        #15;
        adc_busy = 1;
        #(80);
        adc_busy = 0;
        
        // Simulate x position sample
        for (i = 0; i < 12; i = i + 1) begin
            adc_dout = x[11 - i];
            #80;
        end

        #(80*2)
        adc_busy = 1;
        #80;
        adc_busy = 0;

        // Simulate y position sample
        for (i = 0; i < 12; i = i + 1) begin
            adc_dout = y[11 - i];
            #80;
        end

    end

endmodule