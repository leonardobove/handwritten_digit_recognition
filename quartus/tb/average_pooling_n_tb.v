`timescale 1ns / 1ps

module average_pooling_n_tb;

    parameter output_resolution = 8;
    parameter n = 8;
    parameter input_matrix_side_length = 112;
    parameter output_matrix_side_length = input_matrix_side_length >> $clog2(n);
    parameter input_pixel_addr_width = $clog2(input_matrix_side_length**2);

    reg clk;
    reg reset;
    reg en;
    reg start;
    reg input_pixel;
    wire [input_pixel_addr_width-1:0] input_pixel_addr;
    wire [(output_matrix_side_length**2)*output_resolution-1:0] output_pixels;
    wire done;

    // Instantiate the DUT (Device Under Test)
    average_pooling_n #(
        .output_resolution(output_resolution),
        .n(n),
        .input_matrix_side_length(input_matrix_side_length)
    ) dut (
        .clk(clk),
        .reset(reset),
        .en(en),
        .start(start),
        .input_pixel(input_pixel),
        .input_pixel_addr(input_pixel_addr),
        .output_pixels(output_pixels),
        .done(done)
    );

    // Clock generation
    always #5 clk = ~clk; // 10ns period (100 MHz clock)

    // Test stimulus
    integer i, j;
    initial begin
        clk = 0;
        reset = 1;
        en = 0;
        start = 0;
        input_pixel = 0;
        
        // Reset sequence
        #20;
        reset = 0;
        en = 1;
        
        // Start operation
        #10;
        start = 1;
        #10;
        start = 0;
        
        // Test Case 1: Alternating 1s and 0s
        for (i = 0; i < input_matrix_side_length**2; i = i + 1) begin
            @(posedge clk);
            input_pixel = (i % 2 == 0) ? 1'b1 : 1'b0;
        end
        wait (done);
        $display("Test Case 1 Output Pixels: %h", output_pixels);
        
        // Test Case 2: All 1s
        reset = 1;
        #20;
        reset = 0;
        en = 1;
        start = 1;
        #10;
        start = 0;
        for (i = 0; i < input_matrix_side_length**2; i = i + 1) begin
            @(posedge clk);
            input_pixel = 1'b1;
        end
        wait (done);
        $display("Test Case 2 Output Pixels: %h", output_pixels);
        
        // Test Case 3: All 0s
        reset = 1;
        #20;
        reset = 0;
        en = 1;
        start = 1;
        #10;
        start = 0;
        for (i = 0; i < input_matrix_side_length**2; i = i + 1) begin
            @(posedge clk);
            input_pixel = 1'b0;
        end
        wait (done);
        $display("Test Case 3 Output Pixels: %h", output_pixels);
        
        // Test Case 4: Checkerboard Pattern
        reset = 1;
        #20;
        reset = 0;
        en = 1;
        start = 1;
        #10;
        start = 0;
        for (i = 0; i < input_matrix_side_length; i = i + 1) begin
            for (j = 0; j < input_matrix_side_length; j = j + 1) begin
                @(posedge clk);
                input_pixel = ((i + j) % 2 == 0) ? 1'b1 : 1'b0;
            end
        end
        wait (done);
        $display("Test Case 4 Output Pixels: %h", output_pixels);
        
        // End simulation
        #50;
        $stop;
    end
    
endmodule
