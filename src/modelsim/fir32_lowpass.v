module fir32_lowpass (
    input  wire              clk,
    input  wire              rst_n,
    input  wire signed [7:0] x_in,
    output reg  signed [23:0] y_out
);

    // 32 thanh ghi luu mau tin hieu
    reg signed [7:0] x0,  x1,  x2,  x3;
    reg signed [7:0] x4,  x5,  x6,  x7;
    reg signed [7:0] x8,  x9,  x10, x11;
    reg signed [7:0] x12, x13, x14, x15;
    reg signed [7:0] x16, x17, x18, x19;
    reg signed [7:0] x20, x21, x22, x23;
    reg signed [7:0] x24, x25, x26, x27;
    reg signed [7:0] x28, x29, x30, x31;

    // 32 he so FIR doc tu file hex
    reg signed [15:0] h [0:31];

    // Bien tinh tong cac tich
    reg signed [39:0] acc;

    initial begin
        $readmemh("fir_coeff.hex", h);
    end

    // Luu mau va tinh dau ra
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            x0  <= 0;  x1  <= 0;  x2  <= 0;  x3  <= 0;
            x4  <= 0;  x5  <= 0;  x6  <= 0;  x7  <= 0;
            x8  <= 0;  x9  <= 0;  x10 <= 0;  x11 <= 0;
            x12 <= 0;  x13 <= 0;  x14 <= 0;  x15 <= 0;
            x16 <= 0;  x17 <= 0;  x18 <= 0;  x19 <= 0;
            x20 <= 0;  x21 <= 0;  x22 <= 0;  x23 <= 0;
            x24 <= 0;  x25 <= 0;  x26 <= 0;  x27 <= 0;
            x28 <= 0;  x29 <= 0;  x30 <= 0;  x31 <= 0;

            y_out <= 0;
            acc = 0;
        end else begin
            // Dich cac mau cu sang vi tri tiep theo
            x31 <= x30; x30 <= x29; x29 <= x28; x28 <= x27;
            x27 <= x26; x26 <= x25; x25 <= x24; x24 <= x23;
            x23 <= x22; x22 <= x21; x21 <= x20; x20 <= x19;
            x19 <= x18; x18 <= x17; x17 <= x16; x16 <= x15;
            x15 <= x14; x14 <= x13; x13 <= x12; x12 <= x11;
            x11 <= x10; x10 <= x9;  x9  <= x8;  x8  <= x7;
            x7  <= x6;  x6  <= x5;  x5  <= x4;  x4  <= x3;
            x3  <= x2;  x2  <= x1;  x1  <= x0;
            x0 <= x_in;

            // Tinh tong 32 tich
            acc = $signed(x_in) * $signed(h[0])
                + $signed(x0) * $signed(h[1])
                + $signed(x1) * $signed(h[2])
                + $signed(x2) * $signed(h[3])
                + $signed(x3) * $signed(h[4])
                + $signed(x4) * $signed(h[5])
                + $signed(x5) * $signed(h[6])
                + $signed(x6) * $signed(h[7])
                + $signed(x7) * $signed(h[8])
                + $signed(x8) * $signed(h[9])
                + $signed(x9) * $signed(h[10])
                + $signed(x10) * $signed(h[11])
                + $signed(x11) * $signed(h[12])
                + $signed(x12) * $signed(h[13])
                + $signed(x13) * $signed(h[14])
                + $signed(x14) * $signed(h[15])
                + $signed(x15) * $signed(h[16])
                + $signed(x16) * $signed(h[17])
                + $signed(x17) * $signed(h[18])
                + $signed(x18) * $signed(h[19])
                + $signed(x19) * $signed(h[20])
                + $signed(x20) * $signed(h[21])
                + $signed(x21) * $signed(h[22])
                + $signed(x22) * $signed(h[23])
                + $signed(x23) * $signed(h[24])
                + $signed(x24) * $signed(h[25])
                + $signed(x25) * $signed(h[26])
                + $signed(x26) * $signed(h[27])
                + $signed(x27) * $signed(h[28])
                + $signed(x28) * $signed(h[29])
                + $signed(x29) * $signed(h[30])
                + $signed(x30) * $signed(h[31]);

            // Dua ket qua tu Q15 ve thang so nguyen
            y_out <= acc >>> 15;
        end
    end

endmodule

