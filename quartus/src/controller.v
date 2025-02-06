/*
 * This module is the main controller of the entire system.
 * It implements the master FSM and controls the two slave FSM,
 * one responsible of the graphic side and the other responsible
 * of the neural network implementation.
 */
module controller (
    input clk,
    input en,
    input reset,
    input button,

    // Seven segments display interface
    output reg [3:0] output_digit,

    // Graphics interface
    input graphic_driver_initialized,
    input painter_ready,
    output reg clear_display,
    output reg reset_display,
    output reg enable_graphics,

    // Neural network interface
    output reg start_neural_network,
    output reg enable_neural_network,
    output reg reset_neural_network,
    input neural_network_done,
    input [3:0] predicted_digit
);

    // FSM States
    localparam RESET               = 3'd0,
               CLEAR_DISPLAY_START = 3'd1,
               CLEAR_DISPLAY_WAIT  = 3'd2,
               IDLE                = 3'd3,
               FORWARD_STEP        = 3'd4,
               DISPLAY_DIGIT       = 3'd5;

    // Current state and future state
    reg [2:0] Sreg, Snext;

    // Sample output predicted digit from the neural network.
    // The digit is valid when neural_network_done is active.
    reg [3:0] predicted_digit_reg;
    always @ (posedge clk)
        if (reset)
            predicted_digit_reg <= 0;
        else if (en && neural_network_done)
            predicted_digit_reg <= predicted_digit;
        else
            predicted_digit_reg <= predicted_digit_reg;

    // Seven segments display. When predicted digit is ready, display it, as long as the current state
    // is DISPLAY_DIGIT. Otherwise, keep all LEDs turned off, except for the decimal point.
    assign output_digit = (Sreg == DISPLAY_DIGIT) ? predicted_digit_reg : 4'd10; // 4'd10 corresponds to only the decimal point LED turned on

    // Update current state
    always @ (posedge clk)
        if (~reset)
            Sreg <= RESET;
        else
            if (en)
                Sreg <= Snext;
            else
                Sreg <= Sreg;

    // Evaluate next state
    always @ (*)
        case (Sreg)
            RESET:
                Snext = CLEAR_DISPLAY_WAIT;

            CLEAR_DISPLAY_START:
                Snext = CLEAR_DISPLAY_WAIT;

            CLEAR_DISPLAY_WAIT:
                if (painter_ready)
                    Snext = IDLE;
                else
                    Snext = CLEAR_DISPLAY_WAIT;

            IDLE:
                if (button)
                    Snext = FORWARD_STEP;
                else
                    Snext = IDLE;

            FORWARD_STEP:
                if (neural_network_done)
                    Snext = DISPLAY_DIGIT;
                else
                    Snext = FORWARD_STEP;

            DISPLAY_DIGIT:
                if (button)
                    Snext = CLEAR_DISPLAY_START;
                else
                    Snext = DISPLAY_DIGIT;

            default: Snext = RESET;
        endcase

    always @ (Sreg) begin
        case (Sreg)
            RESET: begin
                enable_neural_network = 1'b0;
                enable_graphics = 1'b1;
                reset_neural_network = 1'b1;
                reset_display = 1'b1;
                clear_display = 1'b1;
                start_neural_network = 1'b0;
            end

            CLEAR_DISPLAY_START: begin
                enable_neural_network = 1'b0;
                enable_graphics = 1'b1;
                reset_neural_network = 1'b1;
                reset_display = 1'b0;
                clear_display = 1'b1;
                start_neural_network = 1'b0;
            end

            CLEAR_DISPLAY_WAIT: begin
                enable_neural_network = 1'b0;
                enable_graphics = 1'b1;
                reset_neural_network = 1'b1;
                reset_display = 1'b0;
                clear_display = 1'b0;
                start_neural_network = 1'b0;
            end

            IDLE: begin
                enable_neural_network = 1'b0;
                enable_graphics = 1'b1;
                reset_neural_network = 1'b1;
                reset_display = 1'b0;
                clear_display = 1'b0;
                start_neural_network = 1'b0;
            end

            FORWARD_STEP: begin
                enable_neural_network = 1'b1;
                enable_graphics = 1'b0;
                reset_neural_network = 1'b0;
                reset_display = 1'b0;
                clear_display = 1'b0;
                start_neural_network = 1'b1;
            end

            DISPLAY_DIGIT: begin
                enable_neural_network = 1'b0;
                enable_graphics = 1'b0;
                reset_neural_network = 1'b0;
                reset_display = 1'b0;
                clear_display = 1'b0;
                start_neural_network = 1'b0;
            end

            default: begin
                enable_neural_network = 1'b0;
                enable_graphics = 1'b0;
                reset_neural_network = 1'b1;
                reset_display = 1'b1;
                clear_display = 1'b1;
                start_neural_network = 1'b0;
            end

        endcase
    end

endmodule