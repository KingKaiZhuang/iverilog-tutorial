`timescale 1ns/1ns

module mux2(a, b, c, d);
input a, b, c;
output d;
assign d = c ? b: a;
endmodule

module mux3(a, b, c, ct1, ct2, d);
input a,b,c,ct1,ct2;
output d;
wire o1;
mux2 U1(a,b,ct1,o1);
mux2 U2(o1,c,ct2,d);
endmodule

//mux3的另一種程式寫法
module mux3_1(a, b, c, ct1, ct2, d);
input a,b,c,ct1,ct2;
output d;
assign d = ct2 ? c :
           ct1 ? b : a;
endmodule

module test;
reg a,b,c,ct1,ct2;
wire d, d1;
mux3 U1(a, b, c, ct1, ct2, d);
mux3_1 U2(a, b, c, ct1, ct2, d1);
initial begin
  $dumpfile("vcd/mux3.vcd");
  $dumpvars();
end

integer i;
initial begin
  for(i=0; i<32; i=i+1) begin
    #0 a = i[0]; b = i[1]; c = i[2]; ct1 = i[3]; ct2 = i[4];
    #10 ;
  end
  a = 0; b = 0; c = 0; ct1 = 0; ct2 = 0;
end
endmodule
 
