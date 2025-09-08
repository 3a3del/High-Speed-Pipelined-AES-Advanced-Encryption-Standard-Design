`timescale 1ns / 1ps

// -------------------------------------------------
// Testbench (plain Verilog friendly)
// -------------------------------------------------
module mixcolumns_tb;
    reg clk = 0;
    reg rst_n;
    reg [127:0] a;
    wire [127:0] b;

    // instantiate DUT
    mixcolumns dut (
        .a(a),
        .b(b),
        .clk(clk),
        .rst_n(rst_n)
    );

    // 10ns clock period
    always #5 clk = ~clk;

    // print task: plain Verilog compatible (no SystemVerilog part-select)
    task print_matrix;
        input [127:0] s;
        integer r, c;
        integer idx;
        reg [7:0] byt;
        begin
            for (r = 0; r < 4; r = r + 1) begin
                $write("  ");
                for (c = 0; c < 4; c = c + 1) begin
                    idx = 8 * (r + 4*c); // column-major index
                    // use shift + mask to extract byte (works in plain Verilog)
                    byt = (s >> idx) & 8'hFF;
                    $write("%02h ", byt);
                end
                $write("\n");
            end
        end
    endtask

    initial begin
        // Use the exact vector you gave (same order)
        // Visual comment of the matrix (after shiftrows / input):
        // 49 45 7f 77
        // db 39 02 de
        // 87 53 d2 96
        // 3b 89 f1 1a
        a = 128'h1a_96_de_77_f1_d2_02_7f_89_53_39_45_3b_87_db_49;

        // reset sequence
        rst_n = 0;
        #12;
        rst_n = 1;

        // wait a rising edge so b gets registered value
        @(posedge clk);
        #1;

        $display("\n--- Input state (after ShiftRows) ---");
        print_matrix(a);

        $display("\n--- Output state (after MixColumns) ---");
        print_matrix(b);

        $display("\nSimulation done.");
        $stop;
    end
endmodule
