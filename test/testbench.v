`timescale 1ns/1ps

module testbench;
    reg clk = 0;

    always #250 clk = ~clk;
endmodule