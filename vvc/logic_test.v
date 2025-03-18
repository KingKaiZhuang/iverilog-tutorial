`timescale 1ns/1ns

module AND2(input a, input b, output c);
    assign c = a & b;
endmodule

module OR2(input a, input b, output c);
    assign c = a | b;
endmodule

module NOT(input a, output c);
    assign c = ~a;
endmodule

module NAND2(input a, input b, output c);
    assign c = ~(a & b);
endmodule

module NOR2(input a, input b, output c);
    assign c = ~(a | b);
endmodule

module XOR2(input a, input b, output c);
    assign c = a ^ b;
endmodule

module mux2(input a, input b, input c, output d);
    assign d = c ? b : a;
endmodule

module test;
    reg a1, b1;
    reg ctrl;
    wire c1, c2, c3, c4, c5, c6;
    wire d;
    
    AND2 U1 (.a(a1), .b(b1), .c(c1));
    OR2 U2 (.a(a1), .b(b1), .c(c2));
    NOT U3 (.a(a1), .c(c3));
    NAND2 U4 (.a(a1), .b(b1), .c(c4));
    NOR2 U5 (.a(a1), .b(b1), .c(c5));
    XOR2 U6 (.a(a1), .b(b1), .c(c6));
    mux2 U7 (.a(a1), .b(b1), .c(ctrl), .d(d));
    
    initial begin
        $dumpfile("vcd/logic_test.vcd");
        $dumpvars();
    end
    
    initial begin
        #0  a1 = 0; b1 = 0; ctrl = 0; // 0ns
        #10 a1 = 1;                   // 10ns
        #10 a1 = 0; b1 = 1;           // 20ns
        #10 a1 = 1;                   // 30ns
        #10 a1 = 0; b1 = 0; ctrl = 1; // 40ns
        #10 a1 = 1;                   // 50ns
        #10 a1 = 0; b1 = 1;           // 60ns
        #10 a1 = 1;                   // 70ns
        #10 a1 = 0; b1 = 0; ctrl = 0; // 80ns
    end
endmodule
