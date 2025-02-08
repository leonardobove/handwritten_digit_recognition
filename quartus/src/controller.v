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
    input painter_ready,
    output reg clear_display,
    output reg reset_display,
    output reg enable_graphics,

    // Average pooling interface
    output reg start_average_pooling,
    output reg enable_average_pooling,
    output reg reset_average_pooling,
    input average_pooling_done,

    // Neural network interface
    output reg start_neural_network,
    output reg enable_neural_network,
    output reg reset_neural_network,
    input neural_network_done,
    input [3:0] predicted_digit
);

    // FSM States
    localparam RESET                 = 4'd0,
               CLEAR_DISPLAY_START   = 4'd1,
               CLEAR_DISPLAY_WAIT    = 4'd2,
               IDLE                  = 4'd3,
               AVERAGE_POOLING_START = 4'd4, 
               AVERAGE_POOLING_WAIT  = 4'd5,
               NEURAL_NETWORK_START  = 4'd6,
               NEURAL_NETWORK_WAIT   = 4'd7,
               DISPLAY_DIGIT         = 4'd8;

    // Current state and future state
    reg [3:0] Sreg, Snext;

    // Seven segments display. When predicted digit is ready, display it, as long as the current state
    // is DISPLAY_DIGIT. Otherwise, keep all LEDs turned off, except for the decimal point.
    //assign output_digit = (Sreg == DISPLAY_DIGIT) ? predicted_digit : 4'd10; // 4'd10 corresponds to only the decimal point LED turned on

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
                    Snext = AVERAGE_POOLING_START;
                else
                    Snext = IDLE;

            AVERAGE_POOLING_START:
                Snext = AVERAGE_POOLING_WAIT;

            AVERAGE_POOLING_WAIT:
                if (average_pooling_done)
                    Snext = NEURAL_NETWORK_START;
                else
                    Snext = AVERAGE_POOLING_WAIT;

            NEURAL_NETWORK_START:
                Snext = NEURAL_NETWORK_WAIT;

            NEURAL_NETWORK_WAIT:
                if (neural_network_done)
                    Snext = DISPLAY_DIGIT;
                else
                    Snext = NEURAL_NETWORK_WAIT;

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
                enable_graphics = 1'b0;
                enable_average_pooling = 1'b0;

                reset_neural_network = 1'b1;
                reset_display = 1'b1;
                reset_average_pooling = 1'b1;

                clear_display = 1'b1;
                start_neural_network = 1'b0;
                start_average_pooling = 1'b0;

                output_digit = 4'd0;
            end

            CLEAR_DISPLAY_START: begin
                enable_neural_network = 1'b0;
                enable_graphics = 1'b1;
                enable_average_pooling = 1'b0;

                reset_neural_network = 1'b1;
                reset_display = 1'b0;
                reset_average_pooling = 1'b1;

                clear_display = 1'b1;
                start_neural_network = 1'b0;
                start_average_pooling = 1'b0;

                output_digit = 4'd1;
            end

            CLEAR_DISPLAY_WAIT: begin
                enable_neural_network = 1'b0;
                enable_graphics = 1'b1;
                enable_average_pooling = 1'b0;

                reset_neural_network = 1'b1;
                reset_display = 1'b0;
                reset_average_pooling = 1'b1;

                clear_display = 1'b0;
                start_neural_network = 1'b0;
                start_average_pooling = 1'b0;

                output_digit = 4'd2;
            end

            IDLE: begin
                enable_neural_network = 1'b1;
                enable_graphics = 1'b1;
                enable_average_pooling = 1'b1;

                reset_neural_network = 1'b0;
                reset_display = 1'b0;
                reset_average_pooling = 1'b0;

                clear_display = 1'b0;
                start_neural_network = 1'b0;
                start_average_pooling = 1'b0;

                output_digit = 4'd3;
            end

            AVERAGE_POOLING_START: begin
                enable_neural_network = 1'b1;
                enable_graphics = 1'b0;
                enable_average_pooling = 1'b1;

                reset_neural_network = 1'b0;
                reset_display = 1'b0;
                reset_average_pooling = 1'b0;

                clear_display = 1'b0;
                start_neural_network = 1'b0;
                start_average_pooling = 1'b1;

                output_digit = 4'd4;
            end

            AVERAGE_POOLING_WAIT: begin
                enable_neural_network = 1'b1;
                enable_graphics = 1'b0;
                enable_average_pooling = 1'b1;

                reset_neural_network = 1'b0;
                reset_display = 1'b0;
                reset_average_pooling = 1'b0;

                clear_display = 1'b0;
                start_neural_network = 1'b0;
                start_average_pooling = 1'b0;

                output_digit = 4'd5;
            end

            NEURAL_NETWORK_START: begin
                enable_neural_network = 1'b1;
                enable_graphics = 1'b0;
                enable_average_pooling = 1'b0;

                reset_neural_network = 1'b0;
                reset_display = 1'b0;
                reset_average_pooling = 1'b0;

                clear_display = 1'b0;
                start_neural_network = 1'b1;
                start_average_pooling = 1'b0;

                output_digit = 4'd6;
            end

            NEURAL_NETWORK_WAIT: begin
                enable_neural_network = 1'b1;
                enable_graphics = 1'b0;
                enable_average_pooling = 1'b0;

                reset_neural_network = 1'b0;
                reset_display = 1'b0;
                reset_average_pooling = 1'b0;

                clear_display = 1'b0;
                start_neural_network = 1'b0;
                start_average_pooling = 1'b0;

                output_digit = 4'd7;
            end

            DISPLAY_DIGIT: begin
                enable_neural_network = 1'b0;
                enable_graphics = 1'b0;
                enable_average_pooling = 1'b0;

                reset_neural_network = 1'b0;
                reset_display = 1'b0;
                reset_average_pooling = 1'b0;

                clear_display = 1'b0;
                start_neural_network = 1'b0;
                start_average_pooling = 1'b0;

                output_digit = 4'd8;
            end

            default: begin
                enable_neural_network = 1'b0;
                enable_graphics = 1'b0;
                enable_average_pooling = 1'b0;

                reset_neural_network = 1'b1;
                reset_display = 1'b1;
                reset_average_pooling = 1'b1;

                clear_display = 1'b1;
                start_neural_network = 1'b0;
                start_average_pooling = 1'b0;

                output_digit = 4'd10;
            end

        endcase
    end

endmodule