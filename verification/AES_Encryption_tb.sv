`timescale 1ns / 1ps

module AES_Encryption_tb;
    reg clk;
    reg rst_n;
    reg [127:0] Data_in;
    reg [127:0] key_in;
    wire [127:0] cipher_out;

    // Instantiate DUT (must be in project)
    AES_Encryption dut (
        .clk(clk),
        .rst_n(rst_n),
        .Data_in(Data_in),
        .key_in(key_in),
        .cipher_out(cipher_out)
    );

    // clock
    initial clk = 0;
    always #5 clk = ~clk; // 10 ns period

    // byte buffer for LSB-first extraction
    reg [7:0] bytes [0:15];
    integer i, r, c;

    // Unpack bytes LSB-first: bytes[0] = v[7:0], bytes[1] = v[15:8], ...
    task unpack_bytes_lsb;
        input [127:0] v;
        reg [127:0] tmp;
        integer idx;
        begin
            tmp = v;
            for (idx = 0; idx < 16; idx = idx + 1) begin
                bytes[idx] = tmp[7:0];
                tmp = tmp >> 8;
            end
        end
    endtask

    // Print AES 4x4 state in column-major order:
    // row r prints bytes[c*4 + r] for c=0..3
    task print_state;
        input [127:0] v;
        reg [7:0] ch;
        begin
            unpack_bytes_lsb(v);
            $display("(");
            for (r = 0; r < 4; r = r + 1) begin
                $write("  ");
                for (c = 0; c < 4; c = c + 1) begin
                    ch = bytes[c*4 + r];
                    $write("%02h", ch);
                    if (c < 3) $write(" ");
                end
                $write("  )  ");
                for (c = 0; c < 4; c = c + 1) begin
                    ch = bytes[c*4 + r];
                    if (ch >= 32 && ch <= 126) $write("%c", ch);
                    else $write(".");
                end
                $display("");
            end
            $display(")\n");
        end
    endtask

    initial begin
        // reset
        rst_n = 0;
        Data_in = 128'h0;
        key_in  = 128'h0;
        #20;
        rst_n = 1;

        // Test vectors (exact values requested)
        Data_in = 128'h6f775420656e694e20656e4f206f7754;
        key_in  = 128'h754620676e754b20796d207374616854;

        // wait for DUT to propagate through all rounds (adjust if needed)
        repeat(50) @(posedge clk);

        $display("\n=== ROUND KEYS (round_keys[0..10]) ===");
        for (i = 0; i <= 10; i = i + 1) begin
            $display("Round Key %0d:", i);
            print_state(dut.round_keys[i]);
        end

        $display("=== KEY (roundkey no.0) ===");
        print_state(key_in);

        $display("=== ROUND OUTPUTS (round_reg_out[0..10]) ===");
        for (i = 0; i <= 10; i = i + 1) begin
            // hierarchical peek of internal round register array
            $display("Round %0d:", i);
            print_state(dut.round_reg_out[i]);
        end

        $display("=== FINAL cipher_out ===");
        print_state(cipher_out);

        // linear hex for quick copy/paste
        $display("Data_in    = %032h", Data_in);
        $display("key_in     = %032h", key_in);
        $display("cipher_out = %032h", cipher_out);

        // Additional hex display of all round keys
        $display("\n=== ROUND KEYS (HEX) ===");
        for (i = 0; i <= 10; i = i + 1) begin
            $display("round_key[%0d] = %032h", i, dut.round_keys[i]);
        end

        $finish;
    end

endmodule