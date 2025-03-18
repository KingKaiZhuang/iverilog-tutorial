`timescale 1ns/1ns

`include "vvc/2bit_adder.v"

module adder2(input [1:0] a, input [1:0] b, output [1:0] s, output c);
    wire c0;
    
    halfA U1 (a[0], b[0], s[0], c0);
    fullA U2 (a[1], b[1], c0, s[1], c);
endmodule

module test;
    reg [1:0] a, b;
    wire [1:0] s;
    wire c;
    
    adder2 U1(a, b, s, c);
    
    initial begin
        $dumpfile("vcd/adder2.vcd");
        $dumpvars();
    end
    
    integer i;
    
    initial begin
        for (i = 0; i < 16; i = i + 1) begin
            #0 a = i[1:0]; b = i[3:2];
            #10;
        end
        a = 0; b = 0;
    end
endmodule
