`timescale 1ns / 1ps

module roundkey(a,b,round_key,clk,rst_n);
input [127:0] a;
input [127:0] round_key;
input clk;
input rst_n;
output [127:0] b;

wire [127:0] MM;
//localparam round_key= 128'h6A005C574129D12821DCFA19F36677AC;
assign MM = {
  a[127:120] ^ round_key[127:120], // byte15
  a[119:112] ^ round_key[119:112], // byte14
  a[111:104] ^ round_key[111:104], // byte13
  a[103:96]   ^ round_key[103:96],  // byte12
  a[95:88]    ^ round_key[95:88],   // byte11
  a[87:80]    ^ round_key[87:80],   // byte10
  a[79:72]    ^ round_key[79:72],   // byte9
  a[71:64]    ^ round_key[71:64],   // byte8
  a[63:56]    ^ round_key[63:56],   // byte7
  a[55:48]    ^ round_key[55:48],   // byte6
  a[47:40]    ^ round_key[47:40],   // byte5
  a[39:32]    ^ round_key[39:32],   // byte4
  a[31:24]    ^ round_key[31:24],   // byte3
  a[23:16]    ^ round_key[23:16],   // byte2
  a[15:8]     ^ round_key[15:8],    // byte1
  a[7:0]      ^ round_key[7:0]      // byte0
};

DFF_128 DUT (.clk(clk) , .D(MM) , .Q(b), .rst_n(rst_n));

endmodule
