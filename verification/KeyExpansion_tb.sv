`timescale 1ns / 1ps

module KeyExpansion_tb;
reg clk;
reg rst_n;
reg [127:0] key_in;
wire [127:0] key_out;

// Instantiate DUT
KeyExpansion DUT (.key_in(key_in), .clk(clk), .rst_n(rst_n), .key_out(key_out));

// Clock: 10 ns period
initial clk = 0;
always #5 clk = ~clk;

// Task to display key matrix in readable format
task display_key_matrix;
    input [127:0] key;
    begin
        $display("    [%02h %02h %02h %02h]", key[7:0], key[39:32], key[71:64], key[103:96]);
        $display("    [%02h %02h %02h %02h]", key[15:8],   key[47:40],   key[79:72],   key[111:104]);
        $display("    [%02h %02h %02h %02h]", key[23:16],   key[55:48],   key[87:80],   key[119:112]);
        $display("    [%02h %02h %02h %02h]", key[31:24],   key[63:56],   key[95:88],    key[127:120]);
        $display("");
    end
endtask

// Task to display intermediate values
task display_intermediate_values;
    begin
        $display("  Intermediate Values:");
        $display("    W1_boxed = %08h", DUT.W1_boxed);
        $display("    W4       = %08h", DUT.W4);
        $display("    W5       = %08h", DUT.W5);
        $display("    W6       = %08h", DUT.W6);
        $display("    W7       = %08h", DUT.W7);
        $display("");
    end
endtask

// Task to display complete transformation
task display_transformation;
    input [127:0] input_key;
    input [127:0] output_key;
    input string test_name;
    begin
        $display("================================================================================");
        $display("TEST CASE: %s", test_name);
        $display("================================================================================");
        
        display_key_matrix(input_key);
        display_intermediate_values();
        display_key_matrix(output_key);
        
        $display("Raw Values:");
        $display("  Input:  %032h", input_key);
        $display("  Output: %032h", output_key);
        $display("");
    end
endtask

initial begin
    // Reset
    rst_n = 0;
    key_in = 128'h00000000000000000000000000000000;
    #20;
    rst_n = 1;
    #10;

    // Test vector 1: Known test key
    key_in = 128'h754620676e754b20796d207374616854;
    repeat(5) @(posedge clk);
    display_transformation(key_in, key_out, "Standard Test Vector");

    // Test vector 2
    key_in = 128'h000102030405060708090a0b0c0d0e0f;
    repeat(5) @(posedge clk);
    display_transformation(key_in, key_out, "Standard Test Vector");

    $display("================================================================================");
    $display("SIMULATION COMPLETED");
    $display("================================================================================");
    #10 $finish;
end

endmodule