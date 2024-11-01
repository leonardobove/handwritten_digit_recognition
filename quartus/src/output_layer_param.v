module output_layer_param (
    output reg signed [8*10*30-1:0] weights_HL, // Declare output as a flattened 1D array for weights
    output reg signed [8*10-1:0] biases_HL // Declare output as a flattened 1D array for biases
);

    // Local parameters for initialized weights and biases
    localparam signed [8*10*30-1:0] weights_HL_param =  {
    8'sd61, -8'sd63, -8'sd21, -8'sd5, -8'sd74, -8'sd41, -8'sd87, 8'sd66, 8'sd75, -8'sd88, 8'sd59, -8'sd88, 8'sd17, 8'sd58, -8'sd53, -8'sd57, 8'sd127, -8'sd57, -8'sd41, 8'sd32, -8'sd39, 8'sd10, 8'sd43, 8'sd27, -8'sd13, -8'sd47, -8'sd84, -8'sd18, 8'sd34, -8'sd65,
    -8'sd43, 8'sd49, 8'sd47, -8'sd81, -8'sd82, -8'sd32, -8'sd55, 8'sd17, -8'sd101, 8'sd49, -8'sd123, -8'sd14, -8'sd68, 8'sd28, -8'sd72, -8'sd75, 8'sd20, 8'sd12, 8'sd20, 8'sd51, -8'sd17, 8'sd10, -8'sd4, 8'sd14, 8'sd12, -8'sd128, 8'sd50, -8'sd91, 8'sd38, 8'sd95,
    8'sd38, -8'sd49, 8'sd76, 8'sd61, 8'sd47, -8'sd37, -8'sd41, -8'sd86, 8'sd111, 8'sd35, -8'sd19, -8'sd5, -8'sd2, -8'sd62, 8'sd25, -8'sd12, -8'sd81, 8'sd13, -8'sd4, -8'sd94, -8'sd21, 8'sd18, 8'sd35, -8'sd54, -8'sd20, 8'sd60, 8'sd40, -8'sd63, 8'sd42, 8'sd81,
    -8'sd35, 8'sd47, -8'sd61, 8'sd31, -8'sd14, -8'sd14, 8'sd34, -8'sd55, -8'sd27, -8'sd48, -8'sd67, -8'sd55, -8'sd31, -8'sd60, 8'sd0, 8'sd26, 8'sd4, -8'sd95, 8'sd91, 8'sd45, 8'sd25, -8'sd19, -8'sd49, 8'sd63, -8'sd79, -8'sd41, -8'sd34, 8'sd78, 8'sd14, 8'sd54,
    -8'sd38, 8'sd7, 8'sd46, -8'sd50, 8'sd84, -8'sd79, 8'sd28, 8'sd12, -8'sd72, 8'sd10, 8'sd79, 8'sd32, 8'sd99, 8'sd36, 8'sd87, 8'sd62, 8'sd13, -8'sd31, 8'sd27, 8'sd6, 8'sd66, -8'sd109, 8'sd77, -8'sd4, -8'sd100, -8'sd30, 8'sd5, -8'sd65, 8'sd59, -8'sd112,
    -8'sd56, -8'sd61, 8'sd11, 8'sd53, 8'sd64, -8'sd5, 8'sd80, 8'sd49, 8'sd50, -8'sd48, -8'sd52, 8'sd104, -8'sd51, 8'sd80, -8'sd54, -8'sd5, -8'sd94, -8'sd56, -8'sd28, 8'sd9, -8'sd44, -8'sd5, -8'sd68, 8'sd42, 8'sd12, -8'sd13, -8'sd51, -8'sd36, -8'sd29, -8'sd19,
    8'sd47, 8'sd20, 8'sd82, -8'sd25, -8'sd60, -8'sd37, -8'sd38, -8'sd80, -8'sd73, -8'sd6, 8'sd73, 8'sd41, -8'sd70, -8'sd12, 8'sd44, -8'sd9, -8'sd5, 8'sd55, -8'sd95, 8'sd0, 8'sd10, 8'sd66, -8'sd62, 8'sd74, 8'sd23, 8'sd66, -8'sd28, 8'sd33, -8'sd80, -8'sd86,
    -8'sd63, -8'sd72, -8'sd93, -8'sd52, -8'sd7, -8'sd18, 8'sd70, -8'sd35, -8'sd31, 8'sd15, -8'sd42, 8'sd7, 8'sd64, 8'sd22, -8'sd72, 8'sd31, 8'sd6, 8'sd87, -8'sd42, 8'sd38, 8'sd31, -8'sd40, -8'sd64, -8'sd82, 8'sd33, 8'sd68, 8'sd27, 8'sd25, -8'sd66, 8'sd62,
    -8'sd75, 8'sd5, -8'sd29, 8'sd58, 8'sd18, -8'sd19, -8'sd60, 8'sd56, -8'sd14, 8'sd44, 8'sd17, 8'sd49, -8'sd37, -8'sd57, 8'sd1, 8'sd75, 8'sd2, 8'sd44, 8'sd78, -8'sd51, -8'sd17, 8'sd72, 8'sd81, -8'sd27, -8'sd14, 8'sd32, -8'sd72, -8'sd19, -8'sd74, -8'sd51,
    8'sd43, 8'sd41, -8'sd40, -8'sd39, 8'sd17, 8'sd0, 8'sd9, 8'sd41, -8'sd35, -8'sd51, -8'sd5, -8'sd6, 8'sd2, 8'sd13, 8'sd43, -8'sd30, 8'sd11, -8'sd70, -8'sd48, -8'sd68, -8'sd89, -8'sd35, -8'sd41, -8'sd82, 8'sd49, -8'sd40, 8'sd16, 8'sd61, -8'sd29, 8'sd69
    };
    
    localparam signed [8*10-1:0] biases_HL_param = {
        -8'sd40, -8'sd50, -8'sd25, -8'sd18, -8'sd39, -8'sd32, -8'sd32, -8'sd34, -8'sd18, -8'sd30
    };

    // Assign weights from the localparam to the output
    always @(*) begin
        integer i, j;
        // Assign weights from the flattened localparam to the output
        for (i = 0; i < 10; i = i + 1) begin
            for (j = 0; j < 30; j = j + 1) begin
                weights_HL[(i * 30 + j) * 8 +: 8] = weights_HL_param[i * 30 + j];
            end
            biases_HL[i * 8 +: 8] = biases_HL_param[i];
        end
    end

endmodule
