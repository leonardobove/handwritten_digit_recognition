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
    localparam MAX_CLK_CNT = 7'd72;                 // Maximum number of clock cycles in a sequence
    localparam CNT_NUM_BITS = $clog2(MAX_CLK_CNT);

    reg clk_cnt_reset_reg; // Reset for the clock counter
    reg clk_cnt_en_reg;    // Enable for the clock counter

    wire [CNT_NUM_BITS-1:0] clk_cnt;    // Clock counter
    wire clk_cnt_reset, clk_cnt_en;

    assign clk_cnt_en = clk_cnt_en_reg && en;
    assign clk_cnt_reset = clk_cnt_reset_reg;

    counter #(
        .MAX_VALUE(MAX_CLK_CNT)
    ) clk_counter_instance (
        .clk(clk),
        .en(clk_cnt_en),
        .reset(clk_cnt_reset),
        .count(clk_cnt)
    );

    // Useful parameters for sequence timing
    localparam START_PHASE_END          = 7'd15;
    localparam WAIT_X_PHASE_END         = 7'd17;
    localparam GET_X_PHASE_END          = 7'd45;
    localparam Y_CONVERSION_SETUP_START = 7'd30;
    localparam WAIT_Y_PHASE_END         = 7'd47;
    localparam GET_Y_PHASE_END          = 7'd71;

    // 8 bit serial data to set up ADC conversion
    // Format: {S, A2, A1, A0, MODE, SER/DFR_n, PD1, PD0}
    localparam x_conversion_setup = 8'b10010000; // Conver X position, 12 bit resolution, differential reference, adc_penirq_n enabled, low power
    localparam y_conversion_setup = 8'b11010000; // Conver Y position, 12 bit resolution, differential reference, adc_penirq_n enabled, low power

    // ADC interface
    // ADC clock generation
    reg adc_dclk_reg;
    always @ (posedge clk)
        if (Sreg != IDLE)
            if (en)
                adc_dclk_reg <= ~adc_dclk_reg;
            else
                adc_dclk_reg <= adc_dclk_reg;
        else
            adc_dclk_reg <= 1'b0;

    assign adc_dclk = adc_dclk_reg;
    // Serialize X and Y conversion setup bits
    assign adc_din = (Sreg == START) ? x_conversion_setup[4'd7 - (clk_cnt/2)] : (Sreg == GET_X && clk_cnt >= Y_CONVERSION_SETUP_START) ? y_conversion_setup[4'd7 - ((clk_cnt - Y_CONVERSION_SETUP_START)/2)] : 1'b0;

    // Update FSM state
    always @ (posedge clk)
        if (reset)
            Sreg <= IDLE;
        else if (en)
            Sreg <= Snext;
        else
            Sreg <= Sreg;


    // Update the conversion output
    always @ (posedge clk)
        if (reset) begin
            x_pos <= 12'd0;
            y_pos <= 12'd0;
        end else begin
            if (Sreg == GET_X && (adc_dclk_reg == 1'b0)) // Sample at the positive edge of adc_dclk
                x_pos[5'd11 - ((clk_cnt - WAIT_X_PHASE_END)/2)] <= adc_dout;
            else
                x_pos <= x_pos;

            if (Sreg == GET_Y && (adc_dclk_reg == 1'b0))
                y_pos[5'd11 - ((clk_cnt - WAIT_Y_PHASE_END)/2)] <= adc_dout;
            else
                y_pos <= y_pos;
        end

    // Evaluate next FSM state
    always @ (*)
        case (Sreg)
            IDLE:
                if (~adc_penirq_n)
                    Snext = START;
                else
                    Snext = IDLE;

            START:
                if (clk_cnt == START_PHASE_END)
                    Snext = WAIT_X;
                else
                    Snext = START;

            WAIT_X:
                if (clk_cnt == WAIT_X_PHASE_END)
                    Snext = GET_X;
                else
                    Snext = WAIT_X;

            GET_X:
                if (clk_cnt == GET_X_PHASE_END)
                    Snext = WAIT_Y;
                else
                    Snext = GET_X;

            WAIT_Y:
                if (clk_cnt == WAIT_Y_PHASE_END)
                    Snext = GET_Y;
                else
                    Snext = WAIT_Y;

            GET_Y:
                if (clk_cnt == GET_Y_PHASE_END)
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
                clk_cnt_en_reg = 1'b1;
                clk_cnt_reset_reg = 1'b0;
            end

            GET_X: begin
                adc_cs_n = 1'b0;
                clk_cnt_en_reg = 1'b1;
                clk_cnt_reset_reg = 1'b0;
            end

            WAIT_Y: begin
                adc_cs_n = 1'b0;
                clk_cnt_en_reg = 1'b1;
                clk_cnt_reset_reg = 1'b0;
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