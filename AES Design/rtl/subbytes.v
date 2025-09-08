`timescale 1ns / 1ps

module subbytes(a,b,clk,rst_n);
input [127:0] a;
input clk;
input rst_n;
output [127:0] b;
wire [127:0] MM;

genvar i;
generate
    for(i = 0 ; i <= 120; i=i+8) begin : sbox_loop
        Sbox s_box(a[i+7:i],MM[i+7:i]);
    end
endgenerate

DFF_128 DUT (.clk(clk) , .D(MM) , .Q(b), .rst_n(rst_n));


endmodule
