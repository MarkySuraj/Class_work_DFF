`timescale 1ns/1ps
module D_FF(
    input D, clk, rst,
    output reg Q
);
    always @(posedge clk) begin
        if(rst)
            Q <= 0;
        else 
            Q <= D; 
    end
endmodule

module TB_D;
reg D, clk, rst;
wire Q;

D_FF uut(D, clk, rst, Q);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

   initial begin
        $monitor("t = %0t | rst=%b | clk=%b | D=%b | Q=%b",
            $time, rst, clk, D, Q);

    $dumpfile("D_FF.vcd");
    $dumpvars(0, TB_D);

    rst = 1;
    D = 0;
    #12 rst = 0;
    #10 D = 1;
    #10 D = 0;
    #10 D = 1;
    #10 D = 1;
    #10 D = 0;
    #20 $finish;
    end
endmodule