`timescale 1ns / 1ps

// -------------------------------------------------
// Testbench for roundkey
// -------------------------------------------------
module roundkey_tb;
    reg clk = 0;
    reg rst_n;
    reg [127:0] a;
    wire [127:0] b;

    // Instantiate DUT
    roundkey dut (
        .a(a),
        .b(b),
        .clk(clk),
        .rst_n(rst_n)
    );

    // Clock generation (10ns period)
    always #5 clk = ~clk;

    // Task to print AES 4x4 matrix (column-major order)
    task print_matrix;
        input [127:0] s;
        integer r, c, idx;
        reg [7:0] byt;
        begin
            for (r = 0; r < 4; r = r + 1) begin
                $write("  ");
                for (c = 0; c < 4; c = c + 1) begin
                    idx = 8 * (r + 4*c); // AES column-major indexing
                    byt = (s >> idx) & 8'hFF;
                    $write("%02h ", byt);
                end
                $write("\n");
            end
        end
    endtask

    initial begin
        // Example input state (you can replace with your test vector)
        // Comment shows the intended matrix layout
        // 49 45 7E 77
        // db 39 02 de
        // 87 53 d2 96
        // 3b 89 f1 1a
        a = 128'h1a_96_de_77_f1_d2_02_7e_89_53_39_45_3b_87_db_49;

        // Apply reset
        rst_n = 0;
        #12;
        rst_n = 1;

        // Wait one clock for result to latch
        @(posedge clk);
        #1;

        $display("\n--- Input state (before round key) ---");
        print_matrix(a);

        $display("\n--- Output state (after AddRoundKey) ---");
        print_matrix(b);

        $display("\nSimulation finished.");
        $stop;
    end
endmodule
