`timescale 1ns / 1ps

module shiftrows_tb;

  // DUT ports
  reg  [127:0] a;
  wire [127:0] b;

  // instantiate the DUT
  shiftrows dut (
    .a(a),
    .b(b)
  );

  // helper: extract byte index idx (0 = least-significant byte a[7:0])
  function [7:0] byte_at;
    input [127:0] vec;
    input integer idx;
    begin
      byte_at = vec[8*idx +: 8];
    end
  endfunction

  // print a 4x4 AES-style matrix: row r, col c maps to byte index (4*c + r)
  task print_matrix;
    input [127:0] state;
    integer r, c, idx;
    reg [7:0] by;
    begin
      for (r = 0; r < 4; r = r + 1) begin
        $write("Row %0d : ", r);
        for (c = 0; c < 4; c = c + 1) begin
          idx = 4*c + r;
          by = byte_at(state, idx);
          $write("%02x ", by);
        end
        $write("\n");
      end
    end
  endtask

  initial begin
    $display("\n--- ShiftRows testbench ---\n");

    // Create an input state with bytes 0x00 .. 0x0F
    // byte15 (MSB) .. byte0 (LSB) = 0F 0E ... 01 00
    a = 128'h0F0E0D0C0B0A09080706050403020100;

    $display("Input vector a = %032h", a);
    $display("\nInput matrix (before ShiftRows):");
    print_matrix(a);

    #1; // allow combinational assign to settle
    $display("\nOutput vector b = %032h", b);
    $display("\nOutput matrix (after ShiftRows):");
    print_matrix(b);

    $display("\nTest complete.\n");
    $finish;
  end

endmodule
