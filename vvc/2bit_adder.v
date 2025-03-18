`timescale 1ns/1ns

module halfA(input a, input b, output s, output c);
    assign #1 s = a ^ b;
    assign #1 c = a & b;
endmodule

module fullA(input a, input b, input ci, output s, output c);
    assign #1 s = a ^ b ^ ci;
    assign #1 c = (a & b) | ((a | b) & ci);
endmodule

module add2(input [1:0] a, input [1:0] b, output [1:0] s, output c);
    wire c0;
    
    halfA U1 (a[0], b[0], s[0], c0);
    fullA U2 (a[1], b[1], c0, s[1], c);
endmodule
