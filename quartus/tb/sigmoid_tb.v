`timescale 1ns/1ps

module sigmoid_tb;
    // Testbench variables
    reg [7:0] zed;            // 8-bit input
    wire [7:0] activation;    // 8-bit output

    // Instantiate the sigmoid module
    sigmoid uut (
        .zed(zed),
        .activation(activation)
    );

    // Procedure to run the test cases
    initial begin
        // Display header
        $display("zed\t|\tactivation");
        $display("------------------------");

        // Test cases
        for (zed = 0; zed < 256; zed = zed + 1) begin
            #10; // Small delay to allow output to stabilize
            $display("%d\t|\t%d", zed, activation);
        end

        // End simulation
        $finish;
    end

endmodule