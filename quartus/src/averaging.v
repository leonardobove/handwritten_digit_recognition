module averaging (
    input reset,
    input averaging_go,
    input [resolution*pixels_number-1:0] pixels,
    output [resolution*averaged_pixels_nr-1:0] pixels_averaged,
    output averaging_done
    );

    //parameters
    parameter resolution = 8;
    parameter pixels_number = 784;
    parameter averaged_pixels_nr = 196;
    parameter pixels_address_nr = ($clog2(pixels_number));
    
    reg pixels_enable;
    wire pixels_done;
    reg signed [resolution*averaged_pixels_nr-1:0] pixels_averaged;
    
    // Pixel value registers
    wire signed [resolution-1:0] pixel_in1;
    wire signed [resolution-1:0] pixel_in2;
    wire signed [resolution-1:0] pixel_in3;
    wire signed [resolution-1:0] pixel_in4;
    wire signed [resolution-1:0] pixel_final;
    
    // Pixel address registers
    reg [pixels_address_nr-1:0] pixel_in1_addr;
    reg [pixels_address_nr-1:0] pixel_in2_addr;
    reg [pixels_address_nr-1:0] pixel_in3_addr;
    reg [pixels_address_nr-1:0] pixel_in4_addr;
    reg [pixels_address_nr-1:0] pixel_final_addr = 0;
    reg [pixels_address_nr-1:0] pixel_addr = 0;
    reg [pixels_address_nr-1:0] pixel_row = 0;
    
    // Initialize addresses
    initial
    begin
        pixel_in1_addr <= 8'b00000000;
        pixel_in2_addr <= 8'b00000001;
        pixel_in3_addr <= 8'b00011100; //28
        pixel_in4_addr <= 8'b00011101; //29
        pixels_enable <= 1'b1;
    end
    
    pixels_avaraging #(
        .resolution(resolution)
    ) single_average (
            .clk(clk),
            .pixel_en(pixels_enable),
            .in1(pixel_in1),
            .in2(pixel_in2),
            .in3(pixel_in3),
            .in4(pixel_in4),
            .out(pixel_final),
            .pixel_done(pixels_done)
        );
    
    // Load pixel values
    assign pixel_in1 = pixels[(pixel_in1_addr*resolution) +: resolution];
    assign pixel_in2 = pixels[(pixel_in2_addr*resolution) +: resolution];
    assign pixel_in3 = pixels[(pixel_in3_addr*resolution) +: resolution];
    assign pixel_in4 = pixels[(pixel_in4_addr*resolution) +: resolution];
    
    always @(*) begin
        if (pixels_done) begin // Average done
            // Store the final pooled value into flattened pool vector
            pixels_averaged[(pixel_final_addr*resolution) +: resolution] = pixel_final;
            pixel_addr = pixel_addr + 2; // Increment address
            pixel_row = pixel_row + 2;
            if (pixel_row == 28) begin // End of row, go down by 2 rows
                pixel_addr = pixel_addr + pixel_row;
                pixel_row = 0;
                end
            if (pixel_in4_addr == 783) begin // Global averaging done
                pixels_enable = 0;
                end
            else if (pixel_in4_addr != 783) begin // Update addresses
                pixel_in1_addr = pixel_addr;
                pixel_in2_addr = pixel_addr + 1;
                pixel_in3_addr = pixel_addr + 28;
                pixel_in4_addr = pixel_addr + 29;
                pixel_final_addr = pixel_final_addr + 1;
                end
            end
        else begin
            pixel_in1_addr = 8'b00000000; 
            pixel_in2_addr = 8'b00000001;
            pixel_in3_addr = 8'b00011100; //28
            pixel_in4_addr = 8'b00011101; //29
            pixel_final_addr = 0;
            pixel_row = 0;
            pixel_addr = 0;
            pixels_enable = 1'b1; 
            end       
        end

endmodule