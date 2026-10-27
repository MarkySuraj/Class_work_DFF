`timescale 1ns/1ps
module D_FF(
    input D, clk,
    output reg Q
);
    always @(posedge clk) begin
            Q <= D; 
    end
endmodule
