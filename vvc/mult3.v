`include "vvc/adder3.v"
module mult3(a, b, axb);
input [2:0] a, b;
output [5:0] axb;
wire [2:0] pp0, pp1, pp2;
assign #1 pp0 = a & {3{b[0]}};
assign #1 pp1 = a & {3{b[1]}};
assign #1 pp2 = a & {3{b[2]}};
wire [2:0] s1, s2;
wire c1, c2;
adder3 U1({1'b0, pp0[2:1]}, pp1, s1, c1);
adder3 U2({c1, s1[2:1]}, pp2, s2, c2);
assign axb = {c2, s2, s1[0], pp0[0]};
endmodule


module test;
reg [2:0] a, b;
wire [5:0] axb;

mult3 U1(a, b, axb);
initial begin
  $dumpfile("vcd/mult3.vcd");
  $dumpvars();
end

integer i;
initial begin
  for(i=0; i<64; i=i+1) begin
    #0 a = i[2:0]; b = i[5:3];
    #10 ;
  end
  a = 0; b = 0;
end

always @(a or b or axb)
  $display("%d ns, a = %d, b = %d, axb = %d\n", $time, a, b, axb);


endmodule
