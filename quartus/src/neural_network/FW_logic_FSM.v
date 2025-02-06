module FW_logic_FSM #(
    parameter pixels_averaged_nr = 196,
    parameter WIDTH = 8
)( 
    input clk,
    input reset,
    input start,
    input [pixels_averaged_nr*WIDTH-1:0] averaged_pixels, // For example, 784*8 input pixels
    input en,
    output [3:0] predict_digit,
    output reg done
);

    // Control signals
    reg MLP_go;
    reg predict_digit_go;

    // Internal signals
    wire [10*4*WIDTH-1:0] activated_pixels;
    wire MLP_done;
    wire predict_digit_done;

    // FSM states
    localparam IDLE = 3'b000;
    localparam MLP_START = 3'b001;
    localparam MLP_WAIT = 3'b010;
    localparam PREDICT_DIGIT_START  = 3'b011;
    localparam PREDICT_DIGIT_WAIT  = 3'b100;
    localparam DIGIT_OUT = 3'b101;

    reg [2:0] current_state, next_state;

    // MLP block for predictions
    MLP #(
        .averaged_pixels_nr(pixels_averaged_nr),
        .WIDTH(WIDTH),
        .OL_neurons(10),
        .HL_neurons(32)
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
        .WIDTH(4*WIDTH)
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
            current_state <= IDLE;
        else if (en)
            current_state <= next_state;
        else
            current_state <= current_state;
    end

    // FSM: State transition logic
    always @(*) begin

        case (current_state)
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
                next_state = IDLE;
        endcase
    end

    // FSM: Output control signals
    always @(current_state) begin
            case (current_state)
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
