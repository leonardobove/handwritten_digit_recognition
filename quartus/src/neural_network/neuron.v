module neuron #(
    parameter input_data_size = 1,
    parameter resolution = 8,
    parameter input_data_size_width = ($clog2(input_data_size))
)(
    input clk,                   // Clock signal
    input reset,                 // Reset signal
    input neuron_go,             // Start signal to begin processing
    input [resolution*input_data_size-1:0] input_data, // Flattened input data
    input [resolution*input_data_size-1:0] weight,     // Flattened weights
    input signed [resolution-1:0] bias,               // Bias input
    output reg neuron_done,
    output signed [resolution-1:0] output_neuron // Output neuron value
);

    // FSM States
    localparam IDLE = 3'b000;
    localparam LOAD = 3'b001;
    localparam MAC  = 3'b010;
    localparam WAIT = 3'b011;
    localparam OUTPUT = 3'b100;

    reg [resolution*input_data_size-1:0] input_data_intern;

    reg [2:0] current_state, next_state;
    reg [input_data_size_width-1:0] index; // Counter for input/weight processing
    reg mac_clken, mac_sload;
    reg count_en, count_reset; 
    reg extract_en;

    wire signed [resolution-1:0] input_data_element, weight_element;
    wire signed [2*resolution+input_data_size_width:0] mac_result;
    wire [input_data_size_width-1:0] count_element;

    reg signed [2*resolution+input_data_size_width:0] output_neuron_intern;
    wire signed [resolution+input_data_size_width:0] shifted_output = output_neuron_intern >>> 8;
    wire signed [resolution+input_data_size_width:0] output_neuron_temp;

    // Input-weight extraction module instance
    extract_elements #(
        .resolution(resolution),
        .input_data_size(input_data_size)
    ) extract_inst (
        .clk(clk),
        .extract_en(extract_en),
        .index(count_element),
        .input_data(input_data_intern),
        .weight(weight),
        .input_data_element(input_data_element),
        .weight_element(weight_element)
    );

    // MAC module instance
    signed_multiply_accumulate #(
        .WIDTH(resolution),
        .input_data_size(input_data_size)
    ) mac_inst (
        .clk(clk),
        .aclr(reset),
        .clken(mac_clken),
        .sload(mac_sload),
        .dataa(input_data_element),
        .datab(weight_element),
        .adder_out(mac_result)
    );

    // Counter instance for tracking input/weight elements
    counter #(
        .MAX_VALUE(input_data_size)
    ) count_input_data_element (
        .clk(clk),
        .en(count_en),
        .reset(count_reset),
        .count(count_element)
    );

    always @(posedge clk) begin
        if (neuron_go)
            input_data_intern <= input_data;
        else 
            input_data_intern <= input_data_intern;
    end

    // FSM: State Transitions
    always @(posedge clk) begin
        if (reset) 
            current_state <= IDLE;
        else 
            current_state <= next_state;
    end

    // FSM: State Transition Logic
    always @(*) begin
        next_state = current_state; // Default next state
        case (current_state)
            IDLE:
                if (neuron_go)
                    next_state = LOAD;

            LOAD:
                next_state = MAC;

            MAC:  
                if (count_element == input_data_size - 1)
                    next_state = WAIT;  // Move to WAIT after processing all inputs
                else
                    next_state = LOAD; // Continue loading

            WAIT:
                next_state = OUTPUT;

            OUTPUT:
                next_state = IDLE;

            default:
                next_state = IDLE;
        endcase
    end

    // FSM: Output Control Logic
    always @(*) begin
        // Default signal values
        mac_clken = 1'b0;
        mac_sload = 1'b1;
        count_en = 1'b0;
        count_reset = 1'b0;
        extract_en = 1'b0;

        case (current_state)
            IDLE: begin
                count_reset = 1'b1;
            end

            LOAD: begin
                extract_en = 1'b1;
                count_reset = 1'b0;
                count_en = 1'b1;
                mac_clken = 1'b1;
                mac_sload = 1'b0;
            end

            MAC: begin
                extract_en = 1'b1;
                count_en = 1'b1;
                mac_clken = 1'b1;
                mac_sload = 1'b0;
            end

            WAIT: begin
                count_reset = 1'b1;
                mac_clken = 1'b1;
                mac_sload = 1'b0;
            end

            OUTPUT: begin
                count_reset = 1'b1;
                mac_clken = 1'b1;
                mac_sload = 1'b1;
            end

        endcase
    end

    // Sequential Output Assignment
    always @(*) begin
        case (current_state)
            IDLE: begin
                output_neuron_intern = {2*resolution+input_data_size_width{1'b0}};
                neuron_done = 1'b0;
            end

            OUTPUT: begin
                output_neuron_intern = mac_result + bias;
                neuron_done = 1'b1;
            end

            default: begin
                output_neuron_intern = {2*resolution+input_data_size_width{1'b0}};
                neuron_done = 1'b0;
            end
        endcase
        
    end

    //assign shifted_output = output_neuron_intern >>> 8;
    assign output_neuron_temp = (shifted_output > 8'sb01111111) ? 8'sb01111111 : shifted_output;
    assign output_neuron = (output_neuron_temp < 8'sb10000000) ? 8'sb10000000 : output_neuron_temp[7:0];

endmodule
