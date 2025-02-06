`timescale 1ns / 1ps

module FW_logic_FSM_wrapper_tb;

// Parameters
localparam DATA_WIDTH = 8;       // 8 bits per pixel
localparam VECTOR_SIZE = 196;    // 28x28 pixels for a single MNIST image

integer i;

// Inputs and Outputs
reg clk;
reg reset;
reg start;
wire en;
reg [DATA_WIDTH*VECTOR_SIZE-1:0] input_vector;  // 784 8-bit values in a single vector
wire [3:0] dut_output;           
reg [3:0] expected_output; 
wire done;      

// Instantiate DUT
FW_logic_FSM_wrapper dut (
    .clk(clk),
    .start(start),
    .en(1'b1),
    .reset(reset),
    .pixels_in(input_vector),
    .predict_digit(dut_output),
    .done(done)
);

assign en = 1'b1;

// Clock Generation
initial clk = 0;
always #5 clk = ~clk; // 10ns clock period

// Load Test Vector and Expected Output
initial begin
    // Initialize reset
    reset = 1'b0;
    #20; 
    reset = 1'b1;
    #20;
    reset = 1'b0;
    #20;
    
    $write("----------------------------------------First input----------------------------------------\n");

    start = 1'b1;
    input_vector = { 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00001110, 8'b01110111, 8'b00010100, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00010101, 8'b01111110, 8'b00111110, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00010101, 8'b01111110, 8'b01101000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00001110, 8'b01110111, 8'b01101000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b01101001, 8'b01101000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b01101001, 8'b01101000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00111111, 8'b01111110, 8'b00110000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00111111, 8'b01111110, 8'b01011010, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00100011, 8'b01111110, 8'b01001101, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00001110, 8'b01100010, 8'b00101001, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000 };
    expected_output = 4'd1; // Assuming the digit is 1
    
    #20;
    start = 1'b0;

    // write internal results

    // hidden dense output
    wait(dut.FW_logic_FSM_i.MLP_i.hidden_layer_i.hidden_dense.dense_done);
    $write("Hidden layer output\n");
    $write("[ ");
    for (i = dut.FW_logic_FSM_i.MLP_i.hidden_layer_i.hidden_dense.NEURON_NB; i >= 1; i = i - 1) begin
        $write("%d, ", $signed(dut.FW_logic_FSM_i.MLP_i.hidden_layer_i.hidden_dense.dense_out[(32*i-1)-:32]));
    end
    $write("]\n");

    // relu hidden output
    wait(dut.FW_logic_FSM_i.MLP_i.hidden_layer_i.ReLU_hidden_layer.relu_done);
    $write("Hidden Relu output\n");
    $write("[ ");
    for (i = dut.FW_logic_FSM_i.MLP_i.hidden_layer_i.HL_neurons; i >= 1; i = i - 1) begin
        $write("%d, ", $signed(dut.FW_logic_FSM_i.MLP_i.hidden_layer_i.hidden_out[(32*i-1)-:32]));
    end
    $write("]\n");

    // output dense output
    wait(dut.FW_logic_FSM_i.MLP_i.output_layer_i.output_dense.dense_done);
    $write("Output layer output\n");
    $write("[ ");
    for (i = 1; i <= dut.FW_logic_FSM_i.MLP_i.output_layer_i.OL_neurons; i = i + 1) begin
        $write("%d, ", $signed(dut.FW_logic_FSM_i.MLP_i.output_layer_i.output_dense.dense_out[(32*i-1)-:32]));
    end
    $write("]\n");

    // relu output out
    wait(dut.FW_logic_FSM_i.MLP_i.output_layer_i.ReLU_output_layer.relu_done);
    $write("Output Relu output\n");
    $write("[ ");
    for (i = 1; i <= dut.FW_logic_FSM_i.MLP_i.output_layer_i.OL_neurons; i = i + 1) begin
        $write("%d, ", $signed(dut.FW_logic_FSM_i.MLP_i.output_layer_i.output_out[(32*i-1)-:32]));
    end
    $write("]\n");

    wait(dut.done);

    $write("----------------------------------------Second input----------------------------------------\n");

    start = 1'b1;
    input_vector = { 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00011001, 8'b01000110, 8'b01011110, 8'b01101101, 8'b00110100, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00110001, 8'b00100010, 8'b00001100, 8'b00001010, 8'b01101001, 8'b00000001, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00100010, 8'b01010011, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000011, 8'b00101011, 8'b01110101, 8'b00100110, 8'b00000010, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00111111, 8'b01011011, 8'b01000011, 8'b01001110, 8'b01001000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b01011011, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b01010010, 8'b00000010, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00010010, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00010011, 8'b01101010, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00001001, 8'b01110010, 8'b00101011, 8'b00011000, 8'b00110110, 8'b01110000, 8'b00011111, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00100100, 8'b01101101, 8'b01110010, 8'b01001100, 8'b00011101, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000 };
    expected_output = 4'd3; // Assuming the digit is 3

    #20;
    start = 1'b0;

    // hidden dense output
    wait(dut.FW_logic_FSM_i.MLP_i.hidden_layer_i.hidden_dense.dense_done);
    $write("Hidden layer output\n");
    $write("[ ");
    for (i = 1; i <= dut.FW_logic_FSM_i.MLP_i.hidden_layer_i.HL_neurons; i = i + 1) begin
        $write("%d, ", $signed(dut.FW_logic_FSM_i.MLP_i.hidden_layer_i.hidden_dense.dense_out[(32*i-1)-:32]));
    end
    $write("]\n");
 
    // relu hidden output
    wait(dut.FW_logic_FSM_i.MLP_i.hidden_layer_i.ReLU_hidden_layer.relu_done);
    $write("Hidden Relu output\n");
    $write("[ ");
    for (i = 1; i <= dut.FW_logic_FSM_i.MLP_i.hidden_layer_i.HL_neurons; i = i + 1) begin
        $write("%d, ", $signed(dut.FW_logic_FSM_i.MLP_i.hidden_layer_i.hidden_out[(32*i-1)-:32]));
    end
    $write("]\n");

    // output layer output
    wait(dut.FW_logic_FSM_i.MLP_i.output_layer_i.output_dense.dense_done);
    $write("Output layer output\n");
    $write("[ ");
    for (i = 1; i <= dut.FW_logic_FSM_i.MLP_i.output_layer_i.OL_neurons; i = i + 1) begin
        $write("%d, ", $signed(dut.FW_logic_FSM_i.MLP_i.output_layer_i.output_dense.dense_out[(32*i-1)-:32]));
    end
    $write("]\n");

    // relu output output
    wait(dut.FW_logic_FSM_i.MLP_i.output_layer_i.ReLU_output_layer.relu_done);
    $write("Output Relu output\n");
    $write("[ ");
    for (i = 1; i <= dut.FW_logic_FSM_i.MLP_i.output_layer_i.OL_neurons; i = i + 1) begin
        $write("%d, ", $signed(dut.FW_logic_FSM_i.MLP_i.output_layer_i.output_out[(32*i-1)-:32]));
    end
    $write("]\n");

    wait(dut.done);
    #20;
    
    $finish;
end

endmodule
