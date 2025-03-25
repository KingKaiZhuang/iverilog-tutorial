`include "vvc/adder4.v"

module mult4 (a, b, axb);
    input [3:0] a, b;
    output [7:0] axb;
    wire [3:0] pp0, pp1, pp2, pp3, s1, s2, s3;
    wire c1, c2, c3;


    assign #1 pp0 = a & {b[0], b[0], b[0], b[0]};
    assign #1 pp1 = a & {b[1], b[1], b[1], b[1]};
    assign #1 pp2 = a & {b[2], b[2], b[2], b[2]};
    assign #1 pp3 = a & {b[3], b[3], b[3], b[3]};

    adder4 U1({1'b0, pp0[3:1]}, pp1, s1, c1);
    adder4 U2({c1, s1[3:1]}, pp2, s2, c2);
    adder4 U3({c2, s2[3:1]}, pp3, s3, c3);

    assign axb = {c3, s3, s2[0], s1[0], pp0[0]}; 
endmodule

/*
module test;
    reg [3:0] a, b;
    wire [7:0] axb;

    mult4 U1(a, b, axb);

    initial begin
        $dumpfile("mult4.vcd");
        $dumpvars();
    end

    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            #0 a = i[3:0]; b = i[7:4];
            #10;
        end
        a = 0; b = 0;
    end

    always @(a or b or axb) begin
        $display("%d ns, a = %d, b = %d, axb = %d\n", $time, a, b, axb);
    end
endmodule
*/