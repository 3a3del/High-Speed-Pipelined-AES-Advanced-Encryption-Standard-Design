`timescale 1ns / 1ps

module AES_Encryption(clk,rst_n,Data_in,key_in,cipher_out);
  input clk;
  input rst_n;
  input [127:0] Data_in;
  input [127:0] key_in;
  output [127:0]cipher_out;

  // Parameters
  parameter NUM_ROUNDS = 10;

  // Wire arrays for logic between stages
  wire [127:0] sub_out [1:NUM_ROUNDS];
  wire [127:0] shift_out [1:NUM_ROUNDS];
  wire [127:0] mix_out [1:NUM_ROUNDS];
  wire [127:0] round_out [1:NUM_ROUNDS];

  // Initial round key output and registered output from each round
  wire [127:0] initial_round_out;
  wire [127:0] round_reg_out [0:NUM_ROUNDS];

  // Round keys - now properly generated using KeyExpansion
  wire [127:0] round_keys [0:NUM_ROUNDS];

  // Key expansion instances with different g parameters for each round
  wire [127:0] key_exp_out [1:NUM_ROUNDS];

  // Initial AddRoundKey stage (before round 1)
  roundkey initial_round_key_inst (
             .a(Data_in),                 // Input data
             .b(initial_round_out),       // Output after initial round key
             .round_key(round_keys[0]),   // Initial round key (input key)
             .clk(clk),
             .rst_n(rst_n)
           );

  // Connect initial round key output to round register
  assign round_reg_out[0] = initial_round_out;

  // Assign initial round key (round 0) - the input key
  assign round_keys[0] = key_in;

  // Generate key expansion for each round
  genvar j;
  generate
    for (j = 1; j <= NUM_ROUNDS; j = j + 1)
    begin : gen_key_expansion
      // Calculate g parameter based on round number
      localparam [7:0] g_param = (j == 1) ? 8'h01 :
                 (j == 2) ? 8'h02 :
                 (j == 3) ? 8'h04 :
                 (j == 4) ? 8'h08 :
                 (j == 5) ? 8'h10 :
                 (j == 6) ? 8'h20 :
                 (j == 7) ? 8'h40 :
                 (j == 8) ? 8'h80 :
                 (j == 9) ? 8'h1B :
                 (j == 10) ? 8'h36 : 8'h01;

      KeyExpansion #(.g(g_param)) key_exp_inst (
                     .key_in(round_keys[j-1]),    // Previous round key as input
                     .clk(clk),
                     .rst_n(rst_n),
                     .key_out(key_exp_out[j])     // Expanded key output
                   );

      // Connect key expansion output to round keys
      assign round_keys[j] = key_exp_out[j];
    end
  endgenerate

  // Generate all rounds using for loop
  genvar i;
  generate
    for (i = 1; i <= NUM_ROUNDS; i = i + 1)
    begin : gen_rounds

      // Stage 1: SubBytes
      subbytes sub_bytes_inst (
                 .a(round_reg_out[i-1]),  // Input from previous round register
                 .b(sub_out[i]),          // output
                 .clk(clk),
                 .rst_n(rst_n)
               );

      // Stage 2: ShiftRows
      shiftrows shift_rows_inst (
                  .a(sub_out[i]),          // Direct connection from SubBytes
                  .b(shift_out[i]),        // output
                  .clk(clk),
                  .rst_n(rst_n)
                );

      // Stage 3: MixColumns (skip for final round)
      if (i < NUM_ROUNDS)
      begin : gen_mixcols
        mixcolumns mix_columns_inst (
                     .a(shift_out[i]),    // Direct connection from ShiftRows
                     .b(mix_out[i]),      // output
                     .clk(clk),
                     .rst_n(rst_n)
                   );
      end
      else
      begin : skip_mixcols
        // For final round, bypass MixColumns
        assign mix_out[i] = shift_out[i];
      end

      // Stage 4: AddRoundKey
      roundkey round_key_inst (
                 .a(mix_out[i]),          // Direct connection from MixColumns
                 .b(round_out[i]),        // output
                 .round_key(round_keys[i]), // Use dynamically generated round key
                 .clk(clk),
                 .rst_n(rst_n)
               );

      // Direct assignment - no register between rounds
      assign round_reg_out[i] = round_out[i];

    end
  endgenerate

  // Output assignment
  assign cipher_out = round_reg_out[NUM_ROUNDS];

endmodule
