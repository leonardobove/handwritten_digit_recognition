/*
 * Driver for AD7843 touch screen digitizer.
 *
 * This module returns the position of the pen touch
 * when the screen is touched and pos_ready is true.
 *
 * The 15 DCLKS per cycle mode is used, in order to increase the conversion
 * throughput. This means that the setup of the y position conversion
 * and the serial read of the x position are partially overlapped.
 *
 * The input clock must be 2 MHz maximum.
 */
module lt24_touchscreen_driver (
    input clk,
    input en,
    input reset,
    output reg pos_ready,
    output reg [11:0] x_pos,
    output reg [11:0] y_pos,

    // AD7843 interface
    input adc_penirq_n,
    input adc_dout,
    input adc_busy,
    output adc_din,
    output reg adc_cs_n,
    output adc_dclk
);

    // FSM States
    localparam IDLE   = 3'd0,
               START  = 3'd1,
               WAIT_X = 3'd2,
               GET_X  = 3'd3,
               WAIT_Y = 3'd4,
               GET_Y  = 3'd5,
               DONE   = 3'd6;

    reg [2:0] Sreg, Snext;

    // Clock counter, to keep track of the current position in the conversion sequence
    localparam MAX_CLK_CNT = 4'd15;                 // Maximum number of clock cycles in a sequence
    localparam CNT_NUM_BITS = $clog2(MAX_CLK_CNT);

    reg clk_cnt_reset_reg; // Reset for the clock counter
    reg clk_cnt_en_reg;    // Enable for the clock counter

    wire [CNT_NUM_BITS-1:0] clk_cnt;    // Clock counter
    wire clk_cnt_reset, clk_cnt_en;

    assign clk_cnt_en = clk_cnt_en_reg;
    assign clk_cnt_reset = clk_cnt_reset_reg;

    counter #(
        .MAX_VALUE(MAX_CLK_CNT)
    ) clk_counter_instance (
        .clk(clk),
        .en(clk_cnt_en),
        .reset(clk_cnt_reset),
        .count(clk_cnt)
    );

    // 8 bit serial data to set up ADC conversion
    // Format: {S, A2, A1, A0, MODE, SER/DFR_n, PD1, PD0}
    localparam x_conversion_setup = 8'b10010001; // Conver X position, 12 bit resolution, differential reference, adc_penirq_n enabled, low power
    localparam y_conversion_setup = 8'b11010001; // Conver Y position, 12 bit resolution, differential reference, adc_penirq_n enabled, low power

    // ADC interface
    assign adc_dclk = (Sreg != IDLE) ? ~clk : 1'b0; // Feed clock to ADC when not in IDLE state
    // Serialize X and Y conversion setup bits
    assign adc_din = (Sreg == START) ? x_conversion_setup[4'd7 - clk_cnt] : (Sreg == GET_X && clk_cnt >= 4'd6) ? y_conversion_setup[4'd7 - (clk_cnt - 4'd6)] : 1'b0;

    // Update FSM state
    always @ (posedge clk)
        if (reset) begin
            Sreg <= IDLE;
        end else begin
            Sreg <= Snext;
        end

    // Update the conversion output, considering that the clock is inverted
    // (Sample taken at negative edge of clk)
    always @ (negedge clk)
        if (reset) begin
            x_pos <= 12'd0;
            y_pos <= 12'd0;
        end else begin
            if (Sreg == GET_X)
                x_pos[4'd11 - clk_cnt] <= adc_dout;

            if (Sreg == GET_Y)
                y_pos[4'd11 - clk_cnt] <= adc_dout;
        end

    // Evaluate next FSM state
    always @ (*)
        case (Sreg)
            IDLE:
                if (en && ~adc_penirq_n)
                    Snext = START;
                else
                    Snext = IDLE;

            START:
                if (clk_cnt == 4'd7)
                    Snext = WAIT_X;
                else
                    Snext = START;

            WAIT_X:
                if (adc_busy)
                    Snext = GET_X;
                else
                    Snext = WAIT_X;

            GET_X:
                if (clk_cnt == 4'd13)
                    Snext = WAIT_Y;
                else
                    Snext = GET_X;

            WAIT_Y:
                if (adc_busy)
                    Snext = GET_Y;
                else
                    Snext = WAIT_Y;

            GET_Y:
                if (clk_cnt == 4'd11)
                    Snext = DONE;
                else
                    Snext = GET_Y;

            DONE: Snext = IDLE;

            default: Snext = IDLE;
        endcase

    always @ (Sreg) begin
        pos_ready = 1'b0;
        adc_cs_n = 1'b1;

        clk_cnt_en_reg = 1'b0;
        clk_cnt_reset_reg = 1'b1;

        case (Sreg)
            IDLE: begin
                adc_cs_n = 1'b1;
            end

            START: begin
                adc_cs_n = 1'b0;
                clk_cnt_en_reg = 1'b1;
                clk_cnt_reset_reg = 1'b0;
            end

            WAIT_X: begin
                adc_cs_n = 1'b0;
                clk_cnt_en_reg = 1'b0;
                clk_cnt_reset_reg = 1'b1;
            end

            GET_X: begin
                adc_cs_n = 1'b0;
                clk_cnt_en_reg = 1'b1;
                clk_cnt_reset_reg = 1'b0;
            end

            WAIT_Y: begin
                adc_cs_n = 1'b0;
                clk_cnt_en_reg = 1'b0;
                clk_cnt_reset_reg = 1'b1;
            end

            GET_Y: begin
                adc_cs_n = 1'b0;
                clk_cnt_en_reg = 1'b1;
                clk_cnt_reset_reg = 1'b0;
            end

            DONE: pos_ready = 1'b1;

            default: begin
                adc_cs_n = 1'b1;
                pos_ready = 1'b0;
            end
        endcase
    end

endmodule