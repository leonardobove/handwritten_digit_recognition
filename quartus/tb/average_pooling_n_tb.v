`timescale 1ns / 1ps
 
module average_pooling_n_tb;
 
    parameter output_resolution = 8;
    parameter n = 4;
    parameter input_matrix_side_length = 16;
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
 
    // Create model for input pixels RAM. Only the read feature is needed.
    reg [0:255] ram_content;
    initial ram_content = {128{2'b10}};  // Alternating 1's and 0's pattern
 
    always @ (posedge clk) begin
        input_pixel <= ram_content[input_pixel_addr];
    end
 
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
 
        // Wait for completion
        wait (done);
        $display("Output Pixels: %h", output_pixels);
       
        // End simulation
        #50;
        $stop;
    end
   
endmodule