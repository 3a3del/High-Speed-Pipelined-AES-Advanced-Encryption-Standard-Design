module DFF_128(clk,D,Q,rst_n);
input clk;
input rst_n;
input [127:0] D;
output reg [127:0] Q;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 128'h0;
    end
    else begin
        Q <= D; // Register the combinational result
    end
end
endmodule 