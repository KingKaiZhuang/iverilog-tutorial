`include "vvc/adder.v"

module adder3(a, b, s, c);
input [2:0] a, b;
output [2:0] s;
output c;

wire c0, c1;
halfA U1(a[0], b[0], s[0], c0);
fullA U2(a[1], b[1], c0, s[1], c1);
fullA U3(a[2], b[2], c1, s[2], c);

endmodule

/*
module test;
reg [1:0] a, b;
wire [1:0] s;
wire c;

adder2 U1(a, b, s, c);
initial begin
  $dumpfile("adder2.vcd");
  $dumpvars();
end

integer i;
initial begin
  for(i=0; i<16; i=i+1) begin
    #0 a = i[1:0]; b = i[3:2];
    #10 ;
  end
  a = 0; b = 0;
end

always @(a or b or s or c)
  $display("%d ns, a = %d, b = %d, a+b = %d\n", $time, a, b, {c, s});


endmodule
*/