module neuron #(
    parameter IN_SIZE = 196,
    parameter WIDTH = 8,
    parameter WIDTH_IN = 8,
    parameter WIDTH_OUT = 32
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

    // FSM States
    localparam RESET  = 2'd0,
               IDLE   = 2'd1,
               MAC    = 2'd2,
               OUTPUT = 2'd3;

    reg [1:0] current_state, next_state;
    reg mac_clken, mac_sload;
    reg count_en, count_reset;

    wire signed [WIDTH_OUT-1:0] mac_result;
    wire [$clog2(IN_SIZE)-1:0] index;

    assign neuron_done = (current_state == OUTPUT);
    assign output_neuron = (current_state == OUTPUT) ? mac_result + {{(WIDTH_OUT-WIDTH_IN){bias[7]}}, bias[7:0]} : 32'd0;

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
        .dataa(in_data[(index+1)*WIDTH_IN-1 -: WIDTH_IN]),
        .datab(weight[(index+1)*WIDTH-1 -: WIDTH]),
        .adder_out(mac_result)
    );

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
                    next_state = MAC;
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
