// Module: FW_logic_FSM (Feedforward Logic FSM)
// Description: Controls the execution of an MLP (Multi-Layer Perceptron) network for digit prediction.
// It sequences the computation through MLP activation and digit prediction stages.
//
// Inputs:
// - clk: Clock signal
// - reset: Active-high reset signal
// - start: Start signal to initiate processing
// - en: Enable signal for state transitions
// - averaged_pixels: Flattened input pixel data for MLP
//
// Outputs:
// - predict_digit: 4-bit predicted digit
// - done: Indicates when computation is complete

module FW_logic_FSM #(
    parameter pixels_averaged_nr = 196, // Number of input pixels
    parameter WIDTH = 8
)( 
    input clk,
    input reset,
    input start,
    input [pixels_averaged_nr*WIDTH-1:0] averaged_pixels, // Flattened input pixel data
    input en,
    output [3:0] predict_digit, // Output predicted digit
    output reg done // Done signal indicating completion
);

    // Number of neurons per layer
    localparam HL_neurons = 32,
               OL_neurons = 10;

    // Control signals
    reg MLP_go;
    reg predict_digit_go;

    // Internal signals
    wire [10*4*WIDTH-1:0] activated_pixels; // Output activations from MLP
    wire MLP_done; // MLP computation completion signal
    wire predict_digit_done; // Digit prediction completion signal

    // FSM states
    localparam RESET               = 3'd0, // Reset state
               IDLE                = 3'd1, // Waiting for start signal
               MLP_START           = 3'd2, // Start MLP computation
               MLP_WAIT            = 3'd3, // Wait for MLP completion
               PREDICT_DIGIT_START = 3'd4, // Start digit prediction
               PREDICT_DIGIT_WAIT  = 3'd5, // Wait for digit prediction completion
               DIGIT_OUT           = 3'd6; // Output predicted digit

    // FSM state registers
    reg [2:0] current_state, next_state;

    // MLP block for predictions
    MLP #(
        .averaged_pixels_nr(pixels_averaged_nr),
        .WIDTH(WIDTH),
        .HL_neurons(HL_neurons), // Hidden layer neurons
        .OL_neurons(OL_neurons)  // Output layer neurons 
    ) MLP_i (
        .clk(clk),
        .reset(reset),
        .MLP_go(MLP_go),
        .averaged_pixels(averaged_pixels),
        .MLP_done(MLP_done),
        .output_activations(activated_pixels)
    );

    // Predicted digit block
    predict_digit #(
        .WIDTH(4*WIDTH) // Bit width for prediction module
    ) i_predict_digit (
        .clk(clk),
        .reset(reset),
        .start(predict_digit_go),
        .input_nums(activated_pixels),
        .predicted_digit(predict_digit),
        .done(predict_digit_done)
    );

    // FSM: State transitions
    always @(posedge clk) begin
        if (reset) 
            current_state <= RESET;
        else if (en)
            current_state <= next_state;
        else
            current_state <= current_state;
    end

    // FSM: State transition logic
    always @(*) begin
        case (current_state)
            RESET:
                next_state = IDLE;

            IDLE:
                if (start)
                    next_state = MLP_START;
                else
                    next_state = IDLE;

            MLP_START:
                next_state = MLP_WAIT;

            MLP_WAIT:
                if (MLP_done)  
                    next_state = PREDICT_DIGIT_START;
                else
                    next_state = MLP_WAIT;

            PREDICT_DIGIT_START:
                    next_state = PREDICT_DIGIT_WAIT;

            PREDICT_DIGIT_WAIT:
                if (predict_digit_done)
                    next_state = DIGIT_OUT;
                else
                    next_state = PREDICT_DIGIT_WAIT;

            DIGIT_OUT:
                    next_state = IDLE;

            default: 
                next_state = RESET;
        endcase
    end

    // FSM: Output control signals
    always @(current_state) begin
            case (current_state)
                RESET: begin
                    MLP_go = 1'b0;
                    predict_digit_go = 1'b0;
                    done = 1'b0; 
                end

                IDLE: begin
                    MLP_go = 1'b0;
                    predict_digit_go = 1'b0;
                    done = 1'b0; 
                end

                MLP_START: begin
                    MLP_go = 1'b1;
                    predict_digit_go = 1'b0;
                    done = 1'b0;
                end

                MLP_WAIT: begin
                    MLP_go = 1'b0;
                    predict_digit_go = 1'b0;
                    done = 1'b0;
                end

                PREDICT_DIGIT_START: begin
                    MLP_go = 1'b0;
                    predict_digit_go = 1'b1;
                    done = 1'b0;
                end

                PREDICT_DIGIT_WAIT: begin
                    MLP_go = 1'b0;
                    predict_digit_go = 1'b0;
                    done = 1'b0;
                end

                DIGIT_OUT: begin
                    MLP_go = 1'b0;
                    predict_digit_go = 1'b0;
                    done = 1'b1;                    
                end

                default: begin
                    MLP_go = 1'b0;
                    predict_digit_go = 1'b0;
                    done = 1'b0;  
                end
            endcase
    end
    
endmodule
