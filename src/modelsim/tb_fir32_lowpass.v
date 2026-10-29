`timescale 1ns/1ps

module tb_fir32_lowpass;

    reg clk;
    reg rst_n;
    reg signed [7:0] x_in;
    wire signed [23:0] y_out;

    reg [7:0] input_mem [0:160];

    integer i;
    integer file_out;

    fir32_lowpass uut (
        .clk(clk),
        .rst_n(rst_n),
        .x_in(x_in),
        .y_out(y_out)
    );

    // Tao xung clock chu ky 10 ns
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Doc 161 mau dau vao tu file MATLAB
    initial begin
        $readmemh("fir_input.hex", input_mem);
    end

    // Chay bo loc voi toan bo 161 mau
    initial begin
        rst_n = 0;
        x_in = 0;
        i = 0;
        file_out = 0;

        // Reset mach
        #20;
        rst_n = 1;

        // Mo file ghi ket qua
        file_out = $fopen("fir_output.txt", "w");

        if (file_out == 0) begin
            $display("ERROR: Khong mo duoc fir_output.txt");
            $stop;
        end

        // Dua mau dau vao va ghi ket qua
        while (i < 161) begin
            @(negedge clk);
            x_in = $signed(input_mem[i]);

            @(posedge clk);
            #1;

            $fdisplay(file_out, "%0d", y_out);

            i = i + 1;
        end

        $fclose(file_out);

        $display("-----------------------------------");
        $display("Da xu ly xong 161 mau!");
        $display("Ket qua duoc ghi vao fir_output.txt");
        $display("-----------------------------------");

        $stop;
    end

    // Hien thi tin hieu tren Transcript
    initial begin
        $monitor("time=%0t | rst_n=%b | x_in=%0d | y_out=%0d",
                 $time, rst_n, x_in, y_out);
    end

endmodule

