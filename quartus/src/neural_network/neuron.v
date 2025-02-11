// Module: neuron
// Description:
// This module models a neuron. It performs
// the computation of a weighted sum of input data with a bias term. The module
// multiplies each input by its corresponding weight, sums them, and adds a bias 
// to produce the final output. The module is controlled by a finite state machine 
// (FSM) that manages the stages of computation, including reset, data processing, 
// and output generation.

module neuron #(
    parameter IN_SIZE = 196, // Number of input neurons
    parameter WIDTH = 8, // Bit width of input data and weights
    parameter WIDTH_IN = 8, // Bit width of the input data
    parameter WIDTH_OUT = 32 // Bit width of the output neuron value
)(
    input clk,                                     // Clock signal
    input reset,                                   // Reset signal
    input neuron_go,                               // Start signal to begin processing
    input [WIDTH_IN*IN_SIZE-1:0] in_data,          // Flattened input data
    input [WIDTH*IN_SIZE-1:0] weight,              // Flattened weights
    input signed [WIDTH-1:0] bias,                 // Bias input
    output signed [WIDTH_OUT-1:0] output_neuron,   // Output neuron value
    output neuron_done
);

    // State machine states for FSM (Finite State Machine) control
    localparam RESET  = 2'd0, // Reset state
               IDLE   = 2'd1, // Idle state (waiting for neuron_go signal)
               MAC    = 2'd2, // MAC (Multiply and Accumulate) state for computation
               OUTPUT = 2'd3; // Output state (once computation is done)

    // Register declarations for FSM state, control signals, and counter
    reg [1:0] current_state, next_state;
    reg mac_clken, mac_sload;
    reg count_en, count_reset;

    // Wire declarations
    wire signed [WIDTH_OUT-1:0] mac_result;
    wire [$clog2(IN_SIZE)-1:0] index;

    // Output assignments
    assign neuron_done = (current_state == OUTPUT);
    assign output_neuron = (current_state == OUTPUT) ? mac_result + {{(WIDTH_OUT-WIDTH){bias[7]}}, bias[7:0]} : {(WIDTH_OUT){1'b0}};
    // The output neuron value is the MAC result plus the bias (extended to 32 bit) when in OUTPUT state, otherwise it's 0

    // MAC module instance
    signed_multiply_accumulate #(
        .WIDTH_A(WIDTH_IN),
        .WIDTH_B(WIDTH),
        .WIDTH_OUT(WIDTH_OUT)
    ) mac_inst (
        .clk(clk),
        .aclr(reset),
        .clken(mac_clken),
        .sload(mac_sload),
        .dataa(in_data[(index+1)*WIDTH_IN-1 -: WIDTH_IN]), // Input data slice for current index
        .datab(weight[(index+1)*WIDTH-1 -: WIDTH]), // Weight slice for current index
        .adder_out(mac_result)
    );

    // Instantiate a counter to keep track of the current index in the input data and weights
    counter #(
        .MAX_VALUE(IN_SIZE)
    ) count_input_data_element (
        .clk(clk),
        .en(count_en),
        .reset(count_reset),
        .count(index)
    );

    // FSM: State Transitions
    always @(posedge clk) begin
        if (reset) 
            current_state <= RESET;
        else
            current_state <= next_state;
    end

    // FSM: State Transition Logic
    always @(*) begin
        case (current_state)
            RESET:
                next_state = IDLE;

            IDLE:
                if (neuron_go)
                    next_state = MAC; // Move to MAC state if neuron_go is high
                else
                    next_state = IDLE;

            MAC:
                if (index == IN_SIZE-1)
                    next_state = OUTPUT;  // Move to WAIT after processing all inputs
                else
                    next_state = MAC; // Continue loading

            OUTPUT:  
                next_state = IDLE;

            default:
                next_state = RESET;
        endcase
    end

    //Output Assignment
    always @(current_state) begin      
        case (current_state)
            RESET: begin
                mac_clken = 1'b0;
                mac_sload = 1'b1;
                count_reset = 1'b1;
                count_en = 1'b0;
            end

            IDLE: begin
                mac_clken = 1'b0;
                mac_sload = 1'b1;
                count_reset = 1'b1;
                count_en = 1'b0;
            end

            MAC: begin
                mac_clken = 1'b1;
                mac_sload = 1'b0;
                count_reset = 1'b0;
                count_en = 1'b1;
            end

            OUTPUT: begin
                mac_clken = 1'b0;               
                mac_sload = 1'b0;
                count_reset = 1'b0;
                count_en = 1'b0;
            end

            default: begin
                mac_clken = 1'b0;
                mac_sload = 1'b1;
                count_reset = 1'b1;
                count_en = 1'b0;
            end
        endcase  
    end

endmodule
