`timescale 1ns / 1ps

module mixcolumns(a,b,clk,rst_n);
input [127:0] a;
input clk;
input rst_n;
output [127:0] b;

wire [127:0] MM;

//int temp;
genvar i;
generate
    for ( i = 0 ; i < 4 ; i = i + 1) begin
        //temp = i<<5; //32
        localparam temp = i<<5;
        assign MM[7+temp:temp] = (a[7+temp:temp]<<<1) ^ a[23+temp:16+temp] ^ a[31+temp:24+temp] ^ ((a[15+temp:8+temp]<<<1) ^ a[15+temp:8+temp]);
        assign MM[15+temp:8+temp] = (a[15+temp:8+temp]<<<1) ^ a[7+temp:temp] ^ a[31+temp:24+temp] ^ ((a[23+temp:16+temp]<<<1) ^ a[23+temp:16+temp]);
        assign MM[23+temp:16+temp] = (a[23+temp:16+temp]<<<1) ^ a[7+temp:temp] ^ a[15+temp:8+temp] ^ ((a[31+temp:24+temp]<<<1) ^ a[31+temp:24+temp]);
        assign MM[31+temp:24+temp] = (a[31+temp:24+temp]<<<1) ^ a[15+temp:8+temp] ^ a[23+temp:16+temp] ^ ((a[7+temp:temp]<<<1) ^ a[7+temp:temp]);
    end
endgenerate

DFF_128 DUT (.clk(clk) , .D(MM) , .Q(b), .rst_n(rst_n));


endmodule
