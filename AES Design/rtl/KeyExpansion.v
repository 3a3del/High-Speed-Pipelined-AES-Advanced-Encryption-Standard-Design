`timescale 1ns / 1ps
module KeyExpansion #(parameter g = 8'h01) (key_in,clk,rst_n,key_out);
input [127:0] key_in;
input clk;
input rst_n;
output [127:0] key_out;

wire [31:0] W1_boxed;
wire [31:0] W4;
wire [31:0] W5;
wire [31:0] W6;
wire [31:0] W7;

genvar i;
generate
    for(i = 0 ; i <= 24; i=i+8) begin : sbox_loop
        Sbox s_box(key_in[i+7:i],W1_boxed[i+7:i]);
    end
endgenerate

assign W4 = {W1_boxed [7:0] ^ g , W1_boxed [31:24] ^ g , W1_boxed [23:16] ^ g , W1_boxed [15:8] ^ g};

assign W5 = {key_in[63:56] ^ W4[31:24], key_in[55:48] ^ W4[23:16], key_in[47:40] ^ W4[15:8], key_in[39:32] ^ W4[7:0]}; // w1 XOR W4

assign W6 = {key_in[95:88] ^ W5[31:24], key_in[87:80] ^ W5[23:16], key_in[79:72] ^ W5[15:8], key_in[71:64] ^ W5[7:0]}; // w2 XOR W5

assign W7 = {W6[31:24] ^ key_in[127:120], W6[23:16] ^ key_in[119:112], W6[15:8] ^ key_in[111:104], W6[7:0] ^ key_in[103:96]}; // w3 XOR W6

DFF_128 DUT (.clk(clk) , .D({W7,W6,W5,W4}) , .Q(key_out), .rst_n(rst_n));

endmodule
