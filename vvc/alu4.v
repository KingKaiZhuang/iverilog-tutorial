module ALU4(A, B, cont, Res);
input [3:0] A, B;
input [1:0] cont;
output [7:0] Res;
reg [7:0] Res;

always @(A or B or cont) 
case(cont)
  2'd0: Res <= #1 A + B;
  2'd1: Res <= #1 A * B;
  2'd2: Res <= #1 {A / B, A % B};
  2'd3: Res <= #1 A & B;
endcase
endmodule

module test;
reg [3:0] A, B;
reg [1:0] cont;
wire [7:0] Res;
integer i; // ✅ 補上 i 的宣告

ALU4 U1(A, B, cont, Res);

initial begin
  $dumpfile("vcd/alu4.vcd");
  $dumpvars(0, test);
end

initial begin
  #0 A = 4'd3; B = 4'd11;
  for(i = 0; i < 3; i = i + 1) begin
    #0 cont = i;
    #10 ;
  end

  #10 A = 4'd9; B = 4'd9;
  for(i = 0; i < 3; i = i + 1) begin
    #0 cont = i;
    #10 ;
  end

  #10 A = 4'd12; B = 4'd5;
  for(i = 0; i < 3; i = i + 1) begin
    #0 cont = i;
    #10 ;
  end

  A = 0; B = 0;
end

// ✅ 改成合法的 case 語法
always @(A or B or cont or Res) begin
  case (cont)
    2'd0: $display("%d ns,A=%d, B=%d, A+B = %d\n", $time, A, B, Res);
    2'd1: $display("%d ns,A=%d, B=%d, AxB, Res=%d\n", $time, A, B, Res);
    2'd2: $display("%d ns,A=%d, B=%d, A/B = %d, A除以B之餘數 = %d\n", $time, A, B, Res[7:4], Res[3:0]);
    2'd3: $display("%d ns,A=%d, B=%d, A&B, Res=%d\n", $time, A, B, Res);
  endcase
end

endmodule
