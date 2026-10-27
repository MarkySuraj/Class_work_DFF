module USR_4(
    input clk, shift_load,
    input [3:0] D,
    output [3:0] Q,
    output D_out
);
    wire [3:0] w;
    wire shift_mode = ~shift_load;
    assign w[0] = D[0];
    assign w[1] = (D[1] & shift_mode) | (shift_load & Q[0]);
    assign w[2] = (D[2] & shift_mode) | (shift_load & Q[1]);
    assign w[3] = (D[3] & shift_mode) | (shift_load & Q[2]);

    D_FF D1(.clk(clk), .D(w[0]), .Q(Q[0]));
    D_FF D2(.clk(clk), .D(w[1]), .Q(Q[1]));
    D_FF D3(.clk(clk), .D(w[2]), .Q(Q[2]));
    D_FF D4(.clk(clk), .D(w[3]), .Q(Q[3]));

    assign D_out = Q[3];
endmodule

`timescale 1ns/1ps

module tb_usr_4;
    reg clk;
    reg shift_load;
    reg [3:0] D;

    wire [3:0] Q;
    wire D_out;

    USR_4 dut (
        .clk(clk),
        .shift_load(shift_load),
        .D(D),
        .Q(Q),
        .D_out(D_out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("usr_4.vcd");
        $dumpvars(0, tb_usr_4);

        $monitor(
            "Time=%0t | clk=%b | shift_load=%b | D=%b | Q=%b | D_out=%b",
            $time, clk, shift_load, D, Q, D_out
        );

        // Test 1: Load data (S=0)
        shift_load = 0; D = 4'b1010;
        #10;

        // Test 2: Load different data (S=0)
        shift_load = 0; D = 4'b1101;
        #10;

        // Test 3: Shift operation (S=1)
        shift_load = 1; D = 4'b0111;
        #10;

        // Test 4: Shift again
        shift_load = 1; D = 4'b0010;
        #10;

        // Test 5: Return to load
        shift_load = 0; D = 4'b0101;
        #10;

        // Test 6: Check output Q[3]
        shift_load = 0; D = 4'b1000;
        #10;

        $finish;
    end

endmodule