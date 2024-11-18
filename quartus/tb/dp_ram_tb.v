`timescale 1ns / 1ps

module dp_ram_tb;

    // Parameters
    parameter DATA_WIDTH = 1;
    parameter ADDR_WIDTH = 4;

    // Inputs
    reg [(DATA_WIDTH-1):0] data;
    reg [(ADDR_WIDTH-1):0] read_addr, write_addr;
    reg we, clk;

    // Outputs
    wire [(DATA_WIDTH-1):0] q;

    // Instantiate the RAM module
    simple_dual_port_ram_single_clock #(DATA_WIDTH, ADDR_WIDTH) uut (
        .data(data),
        .read_addr(read_addr),
        .write_addr(write_addr),
        .we(we),
        .clk(clk),
        .q(q)
    );

    // Clock generation
    always #5 clk = ~clk; // 10ns clock period (100 MHz)

    initial begin
        // Initialize inputs
        clk = 0;
        we = 0;
        data = 0;
        write_addr = 0;
        read_addr = 0;

        // Write a '1' to address 3
        #10;                // Wait for a few cycles
        we = 1;
        data = 1'b1;
        write_addr = 4'd3; // Address to write

        #10;                // Wait for one clock cycle
        we = 0;            // Disable write

        // Read back from address 3 after a few cycles
        #20;
        read_addr = 4'd3;  // Address to read
        #10;

        // Finish simulation
        #30;
        $finish;
    end
endmodule
