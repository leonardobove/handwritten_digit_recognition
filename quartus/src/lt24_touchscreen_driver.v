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
 * The input clock must be 2 MHz.
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
    output reg adc_din,
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

    // Feed clock to ADC when not in IDLE state
    assign adc_dclk = (Sreg != IDLE) ? ~clk : 1'b0;

    // Clock counter, to keep track of the current position in the conversion sequence
    reg [3:0] clk_cnt;

    // 8 bit serial data to set up ADC conversion
    // Format: {S, A2, A1, A0, MODE, SER/DFR_n, PD1, PD0}
    localparam x_conversion_setup = 8'b10010000; // Conver X position, 12 bit resolution, differential reference, adc_penirq_n enabled, low power
    localparam y_conversion_setup = 8'b11010000; // Conver Y position, 12 bit resolution, differential reference, adc_penirq_n enabled, low power

    // Update FSM state
    always @ (posedge clk)
        if (reset) begin
            Sreg <= IDLE;
            clk_cnt <= 4'b0;
        end else begin
            Sreg <= Snext;

            // Update clock counter
            if (Sreg == START || Sreg == GET_X || Sreg == GET_Y) begin
                clk_cnt <= clk_cnt + 4'b1;
                if (clk_cnt == 4'd15)   // In case of implausible clock counter, go back to IDLE state
                    Sreg <= IDLE;
            end else if (Sreg == WAIT_X || Sreg == WAIT_Y)
                clk_cnt <= 4'd0;
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

    always @ (Sreg, clk_cnt) begin
        pos_ready = 1'b0;
        adc_cs_n = 1'b1;
        adc_din = 1'b0;

        case (Sreg)
            IDLE: begin
                adc_cs_n = 1'b1;
                adc_din = 1'b0;
            end

            START: begin
                adc_cs_n = 1'b0;
                adc_din = x_conversion_setup[4'd7 - clk_cnt]; // Serialize x conversion setup bits
            end

            WAIT_X: begin
                adc_cs_n = 1'b0;
                adc_din = 1'b0;
            end

            GET_X: begin
                adc_cs_n = 1'b0;
                if (clk_cnt >= 4'd7)
                    adc_din = y_conversion_setup[4'd7 - (clk_cnt - 4'd7)]; // Serialize y conversion setup bits (overlapped to X position reading)
            end

            WAIT_Y: begin
                adc_cs_n = 1'b0;
                adc_din = 1'b0;
            end

            GET_Y: begin
                adc_cs_n = 1'b0;
            end

            DONE: pos_ready = 1'b1;

            default: begin
                adc_cs_n = 1'b1;
                adc_din = 1'b0;
                pos_ready = 1'b0;
            end
        endcase
    end

endmodule