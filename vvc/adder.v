`timescale 1ns/1ns

module halfA(a, b, s, c);
input a, b;
output s, c;
assign #1 s = a ^ b;
assign #1 c = a & b;
endmodule

module fullA(a, b, ci, s, c);
input a,b,ci;
output s, c;
assign #1 s = a ^ b ^ ci;
assign #1 c = (a & b) | ((a|b)&ci);
endmodule

/*
module test;
reg a,b,ci;
wire s1, c1, s2, c2;
halfA U1(a, b, s1, c1);
fullA U2(a, b, ci, s2, c2);

initial begin
  $dumpfile("adder.vcd");
  $dumpvars();
end

integer i;
initial begin
  for(i=0; i<8; i=i+1) begin
    #0 a = i[0]; b = i[1]; ci = i[2];
    #10 ;
  end
  a = 0; b = 0; ci = 0;
end
endmodule
*/
 
