module FW_logic_FSM #(
    parameter pixels_number = 784,
    parameter pixels_averaged_nr = 196,
    parameter resolution = 8
)( 
    input clk,
    input reset,
    input start,
    input [pixels_number*resolution-1:0] pixels, // For example, 784*8 input pixels
    input en,
    output reg [3:0] predicted_digit,
    output reg done
);

    // Control signals
    wire MLP_go;
    reg digit_en;
    reg count_en, count_reset;
    wire [1:0] count_element;

    wire [3:0] predicted_digit_w;
    reg [3:0] predicted_digit_intern;

    always @(posedge clk) begin
        if (reset)
            predicted_digit_intern <= 4'b0000;
        else 
            predicted_digit_intern <= predicted_digit_w;
    end

    // Internal signals
    wire [pixels_number*resolution-1:0] pixel_data;  // Internal wire for pixel data
    wire [pixels_averaged_nr*resolution-1:0] averaged_pixels;
    wire [10*resolution-1:0] activated_pixels;
    wire MLP_done;
    wire [39:0] indices;

    // FSM states
    localparam IDLE = 3'b000;
    localparam POOLING = 3'b001;
    localparam MLP  = 3'b010;
    localparam PREDICTED_DIGIT = 3'b011;
    localparam DIGIT_OUT = 3'b100;

    reg [2:0] current_state, next_state;

    // Assign input pixels to pixel_data
    assign pixel_data = pixels;

    // Instantiate the average_pooling block
    average_pooling #(
        .resolution(resolution),
        .pixels_number(pixels_number),
        .averaged_pixels_nr(pixels_averaged_nr)
    ) avg_pool (
        .clk(clk),
        .reset(reset),
        .pixels(pixel_data),
        .pixels_averaged(averaged_pixels)
    );

    // MLP block for predictions
    MLP #(
        .averaged_pixels_nr(pixels_averaged_nr),
        .resolution(resolution),
        .OL_neurons(10),
        .HL_neurons(30)
    ) mlp (
        .clk(clk),
        .reset(reset),
        .MLP_go(MLP_go),
        .averaged_pixels(averaged_pixels),
        .MLP_done(MLP_done),
        .output_activations(activated_pixels)
    );

    // Counter instance for tracking input/weight elements
    counter #(
        .MAX_VALUE(4)
    ) count_input_data_element (
        .clk(clk),
        .en(count_en),
        .reset(count_reset),
        .count(count_element)
    );

    // Predicted digit block
    predicted_digit i_predicted_digit (
        .clk(clk),
        .reset(reset),
        .en(1'b1),
        .indices(indices),
        .output_activations(activated_pixels),
        .predicted_digit(predicted_digit_w)
    );

    assign indices = {4'b1001, 4'b1000, 4'b0111, 4'b0110, 4'b0101, 4'b0100, 4'b0011, 4'b0010, 4'b0001, 4'b0000};

    // Pulse signal for MLP_go
    reg MLP_go_reg;

    // FSM: State transitions
    always @(posedge clk or posedge reset) begin
        if (reset) 
            current_state <= IDLE;
        else 
            current_state <= next_state;
    end

    // FSM: State transition logic
    always @(*) begin
        // Default next state
        next_state = current_state;

        case (current_state)
            IDLE:
                if (start)
                    next_state = POOLING;
                else
                    next_state = IDLE;

            POOLING:
                next_state = MLP;

            MLP:
                if (MLP_done)  
                    next_state = PREDICTED_DIGIT;
                else
                    next_state = MLP;

            PREDICTED_DIGIT:
                if (count_element == 4 - 1)
                    next_state = DIGIT_OUT;
                else
                    next_state = PREDICTED_DIGIT;

            DIGIT_OUT:
                    next_state = IDLE;

            default: 
                next_state = IDLE;
        endcase
    end

    // Generate a single-cycle pulse for MLP_go
    always @(posedge clk) begin
        if (reset) begin
            MLP_go_reg <= 1'b0;
        end else begin
            // Pulse on transition into MLP state
            MLP_go_reg <= (current_state != MLP && next_state == MLP);
        end
    end

    assign MLP_go = MLP_go_reg; // Assign the pulse to the output

    // FSM: Output control signals
    always @(current_state) begin
            case (current_state)
                IDLE: begin
                    count_reset = 1'b1;
                    count_en = 1'b0;
                    done = 1'b0;
                end

                POOLING: begin
                    count_reset = 1'b0;
                    predicted_digit = 4'b0000;
                    done = 1'b0;
                end

                PREDICTED_DIGIT: begin
                    count_en = 1'b1;
                    predicted_digit = 4'b0000;
                    done = 1'b0;
                end

                DIGIT_OUT: begin
                    count_reset = 1'b1;
                    predicted_digit = predicted_digit_intern;
                    done = 1'b1;
                end

                default: begin
                    count_en = 1'b0;
                    count_reset = 1'b0;
                    done = 1'b0;
                end
            endcase
    end
    
endmodule
