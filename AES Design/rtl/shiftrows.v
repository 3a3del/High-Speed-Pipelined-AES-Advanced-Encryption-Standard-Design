`timescale 1ns / 1ps

module shiftrows(a,b,clk,rst_n);
input clk;
input rst_n;
input [127:0] a;
output [127:0] b;

wire [127:0] MM;

assign MM = {
  a[95:88], // byte15 
  a[55:48], // byte14 
  a[15:8],    // byte13  
  a[103:96],  // byte12
  a[63:56],   // byte11
  a[23:16],   // byte10
  a[111:104], // byte9   
  a[71:64],   // byte8
  a[31:24],   // byte7
  a[119:112],   // byte6
  a[79:72],   // byte5  
  a[39:32],   // byte4
  a[127:120],   // byte3
  a[87:80],   // byte2
  a[47:40],   // byte1 
  a[7:0]      // byte0
};

DFF_128 DUT (.clk(clk) , .D(MM) , .Q(b), .rst_n(rst_n));

endmodule
