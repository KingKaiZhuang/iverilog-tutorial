`include "vvc/adder2.v"

module mult2(a,b,axb);

input[1:0] a,b;
output [3:0] axb;
wire [1:0] pp0, pp1;
assign #1 pp0 = a & {2{b[0]}};
assign #1 pp1 = a & {2{b[1]}};
wire[1:0] s;
wire c;

adder2 U1({1'b0, pp0[1]},pp1,s,c);
assign axb = {c, s, pp0[0]};


endmodule

module test;
reg [1:0] a,b;
wire [3:0] axb;

mult2 U1(a,b,axb);
initial begin
    $dumpfile("vcd/mult2.vcd");
    $dumpvars();
end

integer i;
initial begin
    for(i=0;i<16;i=i+1) begin
        #0 a = i[1:0]; b = i[3:2];
        #10;
    end
    a = 0; b = 0;
end

always @(a or b or axb)
    $display("%d ns, a = %d,b = %d,axb = %d\n", $time,a,b,axb);


endmodule