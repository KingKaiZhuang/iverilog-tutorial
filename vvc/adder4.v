`include "vvc/adder.v"

module adder4(a, b, s, c);
input [3:0] a, b;
output [3:0] s;
output c;

wire c0, c1, c2;
halfA U1(a[0], b[0], s[0], c0);
fullA U2(a[1], b[1], c0, s[1], c1);
fullA U3(a[2], b[2], c1, s[2], c2);
fullA U4(a[3], b[3], c2, s[3], c);

endmodule
