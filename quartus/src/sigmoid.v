module sigmoid(
    input wire signed [7:0] zed,    // 8-bit input value (unsigned)
    output reg [7:0] activation     // 8-bit activationput value (unsigned)
    );

    // Initialize the LUT with precomputed sigmoid values
    always @ * begin
        case (zed)
            8'sb00000000: activation <= 8'sb00000000; // input: -128, activation: 0
            8'sb00000001: activation <= 8'sb00000000; // input: -127, activation: 0
            8'sb00000010: activation <= 8'sb00000000; // input: -126, activation: 0
            8'sb00000011: activation <= 8'sb00000000; // input: -125, activation: 0
            8'sb00000100: activation <= 8'sb00000000; // input: -124, activation: 0
            8'sb00000101: activation <= 8'sb00000000; // input: -123, activation: 0
            8'sb00000110: activation <= 8'sb00000000; // input: -122, activation: 0
            8'sb00000111: activation <= 8'sb00000000; // input: -121, activation: 0
            8'sb00001000: activation <= 8'sb00000000; // input: -120, activation: 0
            8'sb00001001: activation <= 8'sb00000000; // input: -119, activation: 0
            8'sb00001010: activation <= 8'sb00000000; // input: -118, activation: 0
            8'sb00001011: activation <= 8'sb00000000; // input: -117, activation: 0
            8'sb00001100: activation <= 8'sb00000000; // input: -116, activation: 0
            8'sb00001101: activation <= 8'sb00000000; // input: -115, activation: 0
            8'sb00001110: activation <= 8'sb00000000; // input: -114, activation: 0
            8'sb00001111: activation <= 8'sb00000000; // input: -113, activation: 0
            8'sb00010000: activation <= 8'sb00000000; // input: -112, activation: 0
            8'sb00010001: activation <= 8'sb00000000; // input: -111, activation: 0
            8'sb00010010: activation <= 8'sb00000000; // input: -110, activation: 0
            8'sb00010011: activation <= 8'sb00000000; // input: -109, activation: 0
            8'sb00010100: activation <= 8'sb00000000; // input: -108, activation: 0
            8'sb00010101: activation <= 8'sb00000000; // input: -107, activation: 0
            8'sb00010110: activation <= 8'sb00000000; // input: -106, activation: 0
            8'sb00010111: activation <= 8'sb00000000; // input: -105, activation: 0
            8'sb00011000: activation <= 8'sb00000000; // input: -104, activation: 0
            8'sb00011001: activation <= 8'sb00000000; // input: -103, activation: 0
            8'sb00011010: activation <= 8'sb00000000; // input: -102, activation: 0
            8'sb00011011: activation <= 8'sb00000000; // input: -101, activation: 0
            8'sb00011100: activation <= 8'sb00000000; // input: -100, activation: 0
            8'sb00011101: activation <= 8'sb00000000; // input: -99, activation: 0
            8'sb00011110: activation <= 8'sb00000000; // input: -98, activation: 0
            8'sb00011111: activation <= 8'sb00000000; // input: -97, activation: 0
            8'sb00100000: activation <= 8'sb00000001; // input: -96, activation: 1
            8'sb00100001: activation <= 8'sb00000001; // input: -95, activation: 1
            8'sb00100010: activation <= 8'sb00000001; // input: -94, activation: 1
            8'sb00100011: activation <= 8'sb00000001; // input: -93, activation: 1
            8'sb00100100: activation <= 8'sb00000001; // input: -92, activation: 1
            8'sb00100101: activation <= 8'sb00000001; // input: -91, activation: 1
            8'sb00100110: activation <= 8'sb00000001; // input: -90, activation: 1
            8'sb00100111: activation <= 8'sb00000001; // input: -89, activation: 1
            8'sb00101000: activation <= 8'sb00000001; // input: -88, activation: 1
            8'sb00101001: activation <= 8'sb00000001; // input: -87, activation: 1
            8'sb00101010: activation <= 8'sb00000001; // input: -86, activation: 1
            8'sb00101011: activation <= 8'sb00000001; // input: -85, activation: 1
            8'sb00101100: activation <= 8'sb00000001; // input: -84, activation: 1
            8'sb00101101: activation <= 8'sb00000001; // input: -83, activation: 1
            8'sb00101110: activation <= 8'sb00000010; // input: -82, activation: 2
            8'sb00101111: activation <= 8'sb00000010; // input: -81, activation: 2
            8'sb00110000: activation <= 8'sb00000010; // input: -80, activation: 2
            8'sb00110001: activation <= 8'sb00000010; // input: -79, activation: 2
            8'sb00110010: activation <= 8'sb00000010; // input: -78, activation: 2
            8'sb00110011: activation <= 8'sb00000010; // input: -77, activation: 2
            8'sb00110100: activation <= 8'sb00000010; // input: -76, activation: 2
            8'sb00110101: activation <= 8'sb00000010; // input: -75, activation: 2
            8'sb00110110: activation <= 8'sb00000011; // input: -74, activation: 3
            8'sb00110111: activation <= 8'sb00000011; // input: -73, activation: 3
            8'sb00111000: activation <= 8'sb00000011; // input: -72, activation: 3
            8'sb00111001: activation <= 8'sb00000011; // input: -71, activation: 3
            8'sb00111010: activation <= 8'sb00000011; // input: -70, activation: 3
            8'sb00111011: activation <= 8'sb00000011; // input: -69, activation: 3
            8'sb00111100: activation <= 8'sb00000100; // input: -68, activation: 4
            8'sb00111101: activation <= 8'sb00000100; // input: -67, activation: 4
            8'sb00111110: activation <= 8'sb00000100; // input: -66, activation: 4
            8'sb00111111: activation <= 8'sb00000100; // input: -65, activation: 4
            8'sb01000000: activation <= 8'sb00000100; // input: -64, activation: 4
            8'sb01000001: activation <= 8'sb00000101; // input: -63, activation: 5
            8'sb01000010: activation <= 8'sb00000101; // input: -62, activation: 5
            8'sb01000011: activation <= 8'sb00000101; // input: -61, activation: 5
            8'sb01000100: activation <= 8'sb00000110; // input: -60, activation: 6
            8'sb01000101: activation <= 8'sb00000110; // input: -59, activation: 6
            8'sb01000110: activation <= 8'sb00000110; // input: -58, activation: 6
            8'sb01000111: activation <= 8'sb00000110; // input: -57, activation: 6
            8'sb01001000: activation <= 8'sb00000111; // input: -56, activation: 7
            8'sb01001001: activation <= 8'sb00000111; // input: -55, activation: 7
            8'sb01001010: activation <= 8'sb00000111; // input: -54, activation: 7
            8'sb01001011: activation <= 8'sb00001000; // input: -53, activation: 8
            8'sb01001100: activation <= 8'sb00001000; // input: -52, activation: 8
            8'sb01001101: activation <= 8'sb00001001; // input: -51, activation: 9
            8'sb01001110: activation <= 8'sb00001001; // input: -50, activation: 9
            8'sb01001111: activation <= 8'sb00001010; // input: -49, activation: 10
            8'sb01010000: activation <= 8'sb00001010; // input: -48, activation: 10
            8'sb01010001: activation <= 8'sb00001011; // input: -47, activation: 11
            8'sb01010010: activation <= 8'sb00001011; // input: -46, activation: 11
            8'sb01010011: activation <= 8'sb00001100; // input: -45, activation: 12
            8'sb01010100: activation <= 8'sb00001100; // input: -44, activation: 12
            8'sb01010101: activation <= 8'sb00001101; // input: -43, activation: 13
            8'sb01010110: activation <= 8'sb00001101; // input: -42, activation: 13
            8'sb01010111: activation <= 8'sb00001110; // input: -41, activation: 14
            8'sb01011000: activation <= 8'sb00001111; // input: -40, activation: 15
            8'sb01011001: activation <= 8'sb00001111; // input: -39, activation: 15
            8'sb01011010: activation <= 8'sb00010000; // input: -38, activation: 16
            8'sb01011011: activation <= 8'sb00010001; // input: -37, activation: 17
            8'sb01011100: activation <= 8'sb00010010; // input: -36, activation: 18
            8'sb01011101: activation <= 8'sb00010010; // input: -35, activation: 18
            8'sb01011110: activation <= 8'sb00010011; // input: -34, activation: 19
            8'sb01011111: activation <= 8'sb00010100; // input: -33, activation: 20
            8'sb01100000: activation <= 8'sb00010101; // input: -32, activation: 21
            8'sb01100001: activation <= 8'sb00010110; // input: -31, activation: 22
            8'sb01100010: activation <= 8'sb00010111; // input: -30, activation: 23
            8'sb01100011: activation <= 8'sb00011000; // input: -29, activation: 24
            8'sb01100100: activation <= 8'sb00011001; // input: -28, activation: 25
            8'sb01100101: activation <= 8'sb00011010; // input: -27, activation: 26
            8'sb01100110: activation <= 8'sb00011011; // input: -26, activation: 27
            8'sb01100111: activation <= 8'sb00011100; // input: -25, activation: 28
            8'sb01101000: activation <= 8'sb00011101; // input: -24, activation: 29
            8'sb01101001: activation <= 8'sb00011110; // input: -23, activation: 30
            8'sb01101010: activation <= 8'sb00011111; // input: -22, activation: 31
            8'sb01101011: activation <= 8'sb00100000; // input: -21, activation: 32
            8'sb01101100: activation <= 8'sb00100010; // input: -20, activation: 34
            8'sb01101101: activation <= 8'sb00100011; // input: -19, activation: 35
            8'sb01101110: activation <= 8'sb00100100; // input: -18, activation: 36
            8'sb01101111: activation <= 8'sb00100110; // input: -17, activation: 38
            8'sb01110000: activation <= 8'sb00100111; // input: -16, activation: 39
            8'sb01110001: activation <= 8'sb00101000; // input: -15, activation: 40
            8'sb01110010: activation <= 8'sb00101010; // input: -14, activation: 42
            8'sb01110011: activation <= 8'sb00101011; // input: -13, activation: 43
            8'sb01110100: activation <= 8'sb00101101; // input: -12, activation: 45
            8'sb01110101: activation <= 8'sb00101110; // input: -11, activation: 46
            8'sb01110110: activation <= 8'sb00101111; // input: -10, activation: 47
            8'sb01110111: activation <= 8'sb00110001; // input: -9, activation: 49
            8'sb01111000: activation <= 8'sb00110010; // input: -8, activation: 50
            8'sb01111001: activation <= 8'sb00110100; // input: -7, activation: 52
            8'sb01111010: activation <= 8'sb00110110; // input: -6, activation: 54
            8'sb01111011: activation <= 8'sb00110111; // input: -5, activation: 55
            8'sb01111100: activation <= 8'sb00111001; // input: -4, activation: 57
            8'sb01111101: activation <= 8'sb00111010; // input: -3, activation: 58
            8'sb01111110: activation <= 8'sb00111100; // input: -2, activation: 60
            8'sb01111111: activation <= 8'sb00111101; // input: -1, activation: 61
            8'sb00000000: activation <= 8'sb00111111; // input: 0, activation: 63
            8'sb00000001: activation <= 8'sb01000001; // input: 1, activation: 65
            8'sb00000010: activation <= 8'sb01000010; // input: 2, activation: 66
            8'sb00000011: activation <= 8'sb01000100; // input: 3, activation: 68
            8'sb00000100: activation <= 8'sb01000101; // input: 4, activation: 69
            8'sb00000101: activation <= 8'sb01000111; // input: 5, activation: 71
            8'sb00000110: activation <= 8'sb01001000; // input: 6, activation: 72
            8'sb00000111: activation <= 8'sb01001010; // input: 7, activation: 74
            8'sb00001000: activation <= 8'sb01001100; // input: 8, activation: 76
            8'sb00001001: activation <= 8'sb01001101; // input: 9, activation: 77
            8'sb00001010: activation <= 8'sb01001111; // input: 10, activation: 79
            8'sb00001011: activation <= 8'sb01010000; // input: 11, activation: 80
            8'sb00001100: activation <= 8'sb01010001; // input: 12, activation: 81
            8'sb00001101: activation <= 8'sb01010011; // input: 13, activation: 83
            8'sb00001110: activation <= 8'sb01010100; // input: 14, activation: 84
            8'sb00001111: activation <= 8'sb01010110; // input: 15, activation: 86
            8'sb00010000: activation <= 8'sb01010111; // input: 16, activation: 87
            8'sb00010001: activation <= 8'sb01011000; // input: 17, activation: 88
            8'sb00010010: activation <= 8'sb01011010; // input: 18, activation: 90
            8'sb00010011: activation <= 8'sb01011011; // input: 19, activation: 91
            8'sb00010100: activation <= 8'sb01011100; // input: 20, activation: 92
            8'sb00010101: activation <= 8'sb01011110; // input: 21, activation: 94
            8'sb00010110: activation <= 8'sb01011111; // input: 22, activation: 95
            8'sb00010111: activation <= 8'sb01100000; // input: 23, activation: 96
            8'sb00011000: activation <= 8'sb01100001; // input: 24, activation: 97
            8'sb00011001: activation <= 8'sb01100010; // input: 25, activation: 98
            8'sb00011010: activation <= 8'sb01100011; // input: 26, activation: 99
            8'sb00011011: activation <= 8'sb01100100; // input: 27, activation: 100
            8'sb00011100: activation <= 8'sb01100101; // input: 28, activation: 101
            8'sb00011101: activation <= 8'sb01100110; // input: 29, activation: 102
            8'sb00011110: activation <= 8'sb01100111; // input: 30, activation: 103
            8'sb00011111: activation <= 8'sb01101000; // input: 31, activation: 104
            8'sb00100000: activation <= 8'sb01101001; // input: 32, activation: 105
            8'sb00100001: activation <= 8'sb01101010; // input: 33, activation: 106
            8'sb00100010: activation <= 8'sb01101011; // input: 34, activation: 107
            8'sb00100011: activation <= 8'sb01101100; // input: 35, activation: 108
            8'sb00100100: activation <= 8'sb01101100; // input: 36, activation: 108
            8'sb00100101: activation <= 8'sb01101101; // input: 37, activation: 109
            8'sb00100110: activation <= 8'sb01101110; // input: 38, activation: 110
            8'sb00100111: activation <= 8'sb01101111; // input: 39, activation: 111
            8'sb00101000: activation <= 8'sb01101111; // input: 40, activation: 111
            8'sb00101001: activation <= 8'sb01110000; // input: 41, activation: 112
            8'sb00101010: activation <= 8'sb01110001; // input: 42, activation: 113
            8'sb00101011: activation <= 8'sb01110001; // input: 43, activation: 113
            8'sb00101100: activation <= 8'sb01110010; // input: 44, activation: 114
            8'sb00101101: activation <= 8'sb01110010; // input: 45, activation: 114
            8'sb00101110: activation <= 8'sb01110011; // input: 46, activation: 115
            8'sb00101111: activation <= 8'sb01110011; // input: 47, activation: 115
            8'sb00110000: activation <= 8'sb01110100; // input: 48, activation: 116
            8'sb00110001: activation <= 8'sb01110100; // input: 49, activation: 116
            8'sb00110010: activation <= 8'sb01110101; // input: 50, activation: 117
            8'sb00110011: activation <= 8'sb01110101; // input: 51, activation: 117
            8'sb00110100: activation <= 8'sb01110110; // input: 52, activation: 118
            8'sb00110101: activation <= 8'sb01110110; // input: 53, activation: 118
            8'sb00110110: activation <= 8'sb01110111; // input: 54, activation: 119
            8'sb00110111: activation <= 8'sb01110111; // input: 55, activation: 119
            8'sb00111000: activation <= 8'sb01110111; // input: 56, activation: 119
            8'sb00111001: activation <= 8'sb01111000; // input: 57, activation: 120
            8'sb00111010: activation <= 8'sb01111000; // input: 58, activation: 120
            8'sb00111011: activation <= 8'sb01111000; // input: 59, activation: 120
            8'sb00111100: activation <= 8'sb01111000; // input: 60, activation: 120
            8'sb00111101: activation <= 8'sb01111001; // input: 61, activation: 121
            8'sb00111110: activation <= 8'sb01111001; // input: 62, activation: 121
            8'sb00111111: activation <= 8'sb01111001; // input: 63, activation: 121
            8'sb01000000: activation <= 8'sb01111010; // input: 64, activation: 122
            8'sb01000001: activation <= 8'sb01111010; // input: 65, activation: 122
            8'sb01000010: activation <= 8'sb01111010; // input: 66, activation: 122
            8'sb01000011: activation <= 8'sb01111010; // input: 67, activation: 122
            8'sb01000100: activation <= 8'sb01111010; // input: 68, activation: 122
            8'sb01000101: activation <= 8'sb01111011; // input: 69, activation: 123
            8'sb01000110: activation <= 8'sb01111011; // input: 70, activation: 123
            8'sb01000111: activation <= 8'sb01111011; // input: 71, activation: 123
            8'sb01001000: activation <= 8'sb01111011; // input: 72, activation: 123
            8'sb01001001: activation <= 8'sb01111011; // input: 73, activation: 123
            8'sb01001010: activation <= 8'sb01111011; // input: 74, activation: 123
            8'sb01001011: activation <= 8'sb01111100; // input: 75, activation: 124
            8'sb01001100: activation <= 8'sb01111100; // input: 76, activation: 124
            8'sb01001101: activation <= 8'sb01111100; // input: 77, activation: 124
            8'sb01001110: activation <= 8'sb01111100; // input: 78, activation: 124
            8'sb01001111: activation <= 8'sb01111100; // input: 79, activation: 124
            8'sb01010000: activation <= 8'sb01111100; // input: 80, activation: 124
            8'sb01010001: activation <= 8'sb01111100; // input: 81, activation: 124
            8'sb01010010: activation <= 8'sb01111100; // input: 82, activation: 124
            8'sb01010011: activation <= 8'sb01111101; // input: 83, activation: 125
            8'sb01010100: activation <= 8'sb01111101; // input: 84, activation: 125
            8'sb01010101: activation <= 8'sb01111101; // input: 85, activation: 125
            8'sb01010110: activation <= 8'sb01111101; // input: 86, activation: 125
            8'sb01010111: activation <= 8'sb01111101; // input: 87, activation: 125
            8'sb01011000: activation <= 8'sb01111101; // input: 88, activation: 125
            8'sb01011001: activation <= 8'sb01111101; // input: 89, activation: 125
            8'sb01011010: activation <= 8'sb01111101; // input: 90, activation: 125
            8'sb01011011: activation <= 8'sb01111101; // input: 91, activation: 125
            8'sb01011100: activation <= 8'sb01111101; // input: 92, activation: 125
            8'sb01011101: activation <= 8'sb01111101; // input: 93, activation: 125
            8'sb01011110: activation <= 8'sb01111101; // input: 94, activation: 125
            8'sb01011111: activation <= 8'sb01111101; // input: 95, activation: 125
            8'sb01100000: activation <= 8'sb01111101; // input: 96, activation: 125
            8'sb01100001: activation <= 8'sb01111110; // input: 97, activation: 126
            8'sb01100010: activation <= 8'sb01111110; // input: 98, activation: 126
            8'sb01100011: activation <= 8'sb01111110; // input: 99, activation: 126
            8'sb01100100: activation <= 8'sb01111110; // input: 100, activation: 126
            8'sb01100101: activation <= 8'sb01111110; // input: 101, activation: 126
            8'sb01100110: activation <= 8'sb01111110; // input: 102, activation: 126
            8'sb01100111: activation <= 8'sb01111110; // input: 103, activation: 126
            8'sb01101000: activation <= 8'sb01111110; // input: 104, activation: 126
            8'sb01101001: activation <= 8'sb01111110; // input: 105, activation: 126
            8'sb01101010: activation <= 8'sb01111110; // input: 106, activation: 126
            8'sb01101011: activation <= 8'sb01111110; // input: 107, activation: 126
            8'sb01101100: activation <= 8'sb01111110; // input: 108, activation: 126
            8'sb01101101: activation <= 8'sb01111110; // input: 109, activation: 126
            8'sb01101110: activation <= 8'sb01111110; // input: 110, activation: 126
            8'sb01101111: activation <= 8'sb01111110; // input: 111, activation: 126
            8'sb01110000: activation <= 8'sb01111110; // input: 112, activation: 126
            8'sb01110001: activation <= 8'sb01111110; // input: 113, activation: 126
            8'sb01110010: activation <= 8'sb01111110; // input: 114, activation: 126
            8'sb01110011: activation <= 8'sb01111110; // input: 115, activation: 126
            8'sb01110100: activation <= 8'sb01111110; // input: 116, activation: 126
            8'sb01110101: activation <= 8'sb01111110; // input: 117, activation: 126
            8'sb01110110: activation <= 8'sb01111110; // input: 118, activation: 126
            8'sb01110111: activation <= 8'sb01111110; // input: 119, activation: 126
            8'sb01111000: activation <= 8'sb01111110; // input: 120, activation: 126
            8'sb01111001: activation <= 8'sb01111110; // input: 121, activation: 126
            8'sb01111010: activation <= 8'sb01111110; // input: 122, activation: 126
            8'sb01111011: activation <= 8'sb01111110; // input: 123, activation: 126
            8'sb01111100: activation <= 8'sb01111110; // input: 124, activation: 126
            8'sb01111101: activation <= 8'sb01111110; // input: 125, activation: 126
            8'sb01111110: activation <= 8'sb01111110; // input: 126, activation: 126
            8'sb01111111: activation <= 8'sb01111110; // input: 127, activation: 126
        endcase
    end

endmodule