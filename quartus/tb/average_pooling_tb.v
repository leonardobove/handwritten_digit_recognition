module average_pooling_tb;

    parameter resolution = 8;
    parameter pixels_number = 784;
    parameter averaged_pixels_nr = 196;

    reg clk = 0;
    reg reset;

    reg [resolution*pixels_number-1:0] pixels;
    wire [resolution*averaged_pixels_nr-1:0] pixels_averaged;

    // Instantiate the DUT (Device Under Test)
    average_pooling_wrapper #(
        .resolution(resolution),
        .pixels_number(pixels_number),
        .averaged_pixels_nr(averaged_pixels_nr)
    )dut (
        .clk(clk),
        .reset(reset),
        .pixels(pixels),
        .pixels_averaged(pixels_averaged)
    );

    // Test Variables
    integer i;

    // Clock generation
    initial begin
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Testbench Procedure
    initial begin
        // Initialize the inputs
        reset = 0;
        pixels = {pixels_number{8'h00}}; // Initialize all pixels to zero
        #5;
        reset = 1;
        #5;
        reset = 0;
        #5;

        // Wait for the output to be ready (allowing time for operations to complete)
        #100;

        // Apply test data to the input pixels
        for (i = 0; i < pixels_number; i = i + 1) begin
            pixels[i*resolution +: resolution] = i; // Fill with values 0, 1, ..., 255, wrapping around
        end

        #100;

        // Apply test data to the input pixels
        for (i = 0; i < pixels_number; i = i + 1) begin
            pixels[i*resolution +: resolution] = 3; // Fill with values 0, 1, ..., 255, wrapping around
        end


        // Finish the simulation
        #700 $finish;
    end

endmodule
