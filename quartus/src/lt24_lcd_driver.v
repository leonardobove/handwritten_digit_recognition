/*
 * Driver for ILI9341 chip driving a 240x320 RGB display.
 *
 * This module takes the output signals and converts them to
 * IL9341 signals following the 16-bit 8080-I serial parallel interface.
 *
 * The input clock should be 4 times the PPU's clock (i.e., 16 MHz).
 * The module will write data to the ILI9341 at half this speed (i.e., 8 MHz).
 */

module lt24_lcd_driver (
    input clk,
    input en,
    input reset,
    input [15:0] pixel_rgb, // 16-bit RGB code (5-bit red, 6-bit green, 5-bit blue)
    input print,
    output done,
    output initialized,

    output tft_rst,
    output tft_csx,
    output tft_dcx,
    output tft_wrx,
    output tft_rdx,
    output [15:0] tft_data
);

    localparam RESTART     = 0,
               IDLE        = 1,
               PRINT_PIXEL = 2;
    
    localparam RESET_START = 0,
               RESET_LO    = 1,
               RESET_WAIT  = 2,
               RESET_INIT  = 3,
               RESET_CLEAR = 4,
               RESET_INIT2 = 5,
               RESET_DONE  = 6;
    localparam RESET_CLKS = 24'd5; //500000; // ~30ms
    reg [2:0] reset_stage;
    reg [23:0] reset_clks;

    reg done_flag;

    reg [1:0] Sreg, Snext;

    reg [17:0] clear_cnt;

    reg write_busy;         // Flag to add 1 clock cycle latency during write sequence, as per ILI9341 reference manual
    reg [16:0] write_data;   // Parallel data to send to ILI9341
    
    localparam INIT_LEN = 49;
    reg [15:0] INIT_DAT [0:INIT_LEN-1]; // List of commands during reset process
    reg [5:0] init_cnt;

    localparam INIT2_LEN = 11;
    reg [15:0] INIT2_DAT [0:INIT2_LEN-1];  // List of commands during pixel draw process
    reg [5:0] init2_cnt;

    initial begin
        // Display OFF
        INIT_DAT[0]   = {1'b0, 16'h28};
        // Power control A
        INIT_DAT[1]   = {1'b0, 16'hCB};
         INIT_DAT[2]  = {1'b1, 16'h39};
         INIT_DAT[3]  = {1'b1, 16'h2C};
         INIT_DAT[4]  = {1'b1, 16'h00};
         INIT_DAT[5]  = {1'b1, 16'h34};
         INIT_DAT[6]  = {1'b1, 16'h02};
        // Power control B
        INIT_DAT[7]   = {1'b0, 16'hCF};
         INIT_DAT[8]  = {1'b1, 16'h00};
         INIT_DAT[9]  = {1'b1, 16'hC1};
         INIT_DAT[10] = {1'b1, 16'h30};
        // Driver timing control A
        INIT_DAT[11]  = {1'b0, 16'hE8};
         INIT_DAT[12] = {1'b1, 16'h85};
         INIT_DAT[13] = {1'b1, 16'h00};
         INIT_DAT[14] = {1'b1, 16'h78};
        // Driver timing control B
        INIT_DAT[15]  = {1'b0, 16'hEA};
         INIT_DAT[16] = {1'b1, 16'h00};
         INIT_DAT[17] = {1'b1, 16'h00};
        // Power on sequence control
        INIT_DAT[18]  = {1'b0, 16'hED};
         INIT_DAT[19] = {1'b1, 16'h64};
         INIT_DAT[20] = {1'b1, 16'h03};
         INIT_DAT[21] = {1'b1, 16'h12};
         INIT_DAT[22] = {1'b1, 16'h81};
        // Pump ratio control
        INIT_DAT[23]  = {1'b0, 16'hF7};
         INIT_DAT[24] = {1'b1, 16'h20};
        // Power Control 1: 4.60 V
        INIT_DAT[25]  = {1'b0, 16'hC0};
         INIT_DAT[26] = {1'b1, 16'h23};
        // Power Control 2: AVDD=VCI*2, VGH=VCI*7, VGL=-VCI*4
        INIT_DAT[27]  = {1'b0, 16'hC1};
         INIT_DAT[28] = {1'b1, 16'h10};
        // VCOM Control 1: VMH=4.25V, VML=-1.5V
        INIT_DAT[29]  = {1'b0, 16'hC5};
         INIT_DAT[30] = {1'b1, 16'h3e};
         INIT_DAT[31] = {1'b1, 16'h28};
        // VCOM Control 2: VMH-58, VML-58
        INIT_DAT[32]  = {1'b0, 16'hC7};
         INIT_DAT[33] = {1'b1, 16'h86};
        // Memory Access Control: Flip Y, RGB bit order
        INIT_DAT[34]  = {1'b0, 16'h36};
         INIT_DAT[35] = {1'b1, 16'h88};
        // Pixel format: RGB565 (16 bits / pixel)
        INIT_DAT[36]  = {1'b0, 16'h3A};
         INIT_DAT[37] = {1'b1, 16'h55};
        // Frame Rate: 70 Hz
        INIT_DAT[38]  = {1'b0, 16'hB1};
         INIT_DAT[39] = {1'b1, 16'h00};
         INIT_DAT[40] = {1'b1, 16'h1B};
        // Display Function Control
        INIT_DAT[41]  = {1'b0, 16'hB6};
         INIT_DAT[42] = {1'b1, 16'h08};
         INIT_DAT[43] = {1'b1, 16'h82};
         INIT_DAT[44] = {1'b1, 16'h27};
         INIT_DAT[45] = {1'b1, 16'h00};
        // Exit sleep
        INIT_DAT[46] =  {1'b0, 16'h11};
        // Display ON
        INIT_DAT[47]  = {1'b0, 16'h29};
        // Start memory write (all following data is pixel data)
        INIT_DAT[48]  = {1'b0, 16'h2C};


        // Set column range: 40..199 (160 pix starting at x=40)
        INIT2_DAT[0]  = {1'b0, 16'h2A};
         INIT2_DAT[1] = {1'b1, 16'h00};
         INIT2_DAT[2] = {1'b1, 16'h28};
         INIT2_DAT[3] = {1'b1, 16'h00};
         INIT2_DAT[4] = {1'b1, 16'hc7};
        // Set row range: 40..183 (144 pix starting at y=40)
        INIT2_DAT[5]  = {1'b0, 16'h2B};
         INIT2_DAT[6] = {1'b1, 16'h00};
         INIT2_DAT[7] = {1'b1, 16'h28};
         INIT2_DAT[8] = {1'b1, 16'h00};
         INIT2_DAT[9] = {1'b1, 16'hb7};
        // Start memory write (all following data is pixel data)
        INIT2_DAT[10]  = {1'b0, 16'h2C};
    end

    assign tft_rst = reset_stage != RESET_LO;
    assign tft_csx = 0; // Chip select enable (active low)
    assign tft_rdx = 1; // Read disable (active low)
    assign tft_wrx = ~write_busy; // Pulse write (active low)
    assign tft_dcx = write_data[16]; // Command/Data select
    assign tft_data = write_data[15:0];
    assign initialized = !reset && reset_stage == RESET_DONE &&
                         reset_clks == 0 && init_cnt == INIT_LEN;
    assign done = done_flag;
    
    always @ (posedge clk)
        if (reset)
            Sreg <= RESTART;
        else Sreg <= Snext;

    always @ (*)
        case (Sreg)
            RESTART: if (initialized) Snext = IDLE;

            IDLE: if (print && en) Snext = PRINT_PIXEL;
                  else Snext = IDLE;

            PRINT_PIXEL:
                if (done || ~en) begin
                    Snext = IDLE;
                end
            default: Snext <= RESTART;
        endcase

    // Synchronous output layer. It is needed in order to control the timing of the instructions
    always @ (posedge clk)
        if (reset) begin
            init_cnt <= 0;
            init2_cnt <= 0;
            write_busy <= 0;
            write_data <= 0;
            reset_stage <= RESET_START;
            reset_clks <= RESET_CLKS;
            clear_cnt <= 320*240*2;
            done_flag <= 0;
        end else
                case (Sreg)
                    RESTART: begin
                        if (|reset_clks)
                            reset_clks <= reset_clks - 1;
                        else if (reset_stage == RESET_START ||
                                 reset_stage == RESET_LO ||
                                 reset_stage == RESET_WAIT ||
                                 (reset_stage == RESET_INIT && init_cnt == INIT_LEN) ||
                                 (reset_stage == RESET_CLEAR && clear_cnt == 0) ||
                                 (reset_stage == RESET_INIT2 && init2_cnt == INIT2_LEN)) begin
                            reset_stage <= reset_stage + 1;
                            reset_clks <= RESET_CLKS;
                        end else if (write_busy) begin
                            write_busy <= 0;
                        end else if (init_cnt < INIT_LEN) begin
                            write_data <= INIT_DAT[init_cnt];
                            write_busy <= 1;
                            init_cnt <= init_cnt + 1;
                        end else if (|clear_cnt) begin
                            write_data <= {1'b1, 16'b0};
                            write_busy <= 1;
                            clear_cnt <= clear_cnt - 1;
                        end else if (init2_cnt < INIT2_LEN) begin
                            write_data <= INIT2_DAT[init2_cnt];
                            write_busy <= 1;
                            init2_cnt <= init2_cnt + 1;
                        end 
                    end
                    
                    PRINT_PIXEL: begin
                        if (write_busy) begin
                            write_busy <= 0;
                            done_flag <= 1;
                        end else if (print) begin
                            write_busy <= 1;
                            write_data <= {1'b1, pixel_rgb};
                        end
                    end
    
                    default: begin
                        write_data = 0;
                    end
                endcase

endmodule