`timescale 1ns/1ns
//偵測1101串列
module det1101(clock, reset_, D, out);
input clock, reset_, D;
output out;
reg det1, det11, det110, det1101;

always @(posedge clock)
if(~reset_) det1 <= #1 1'b0;
else det1 <= #1 D;

always @(posedge clock)
if(~reset_) det11 <= #1 1'b0;
else if (det1 & D) det11 <= #1 1'b1;
else det11 <= #1 1'b0;

always @(posedge clock)
if(~reset_) det110 <= #1 1'b0;
else if (det11 & ~D) det110 <= #1 1'b1;
else det110 <= #1 1'b0;

always @(posedge clock)
if(~reset_) det1101 <= #1 1'b0;
else if (det110 & D) det1101 <= #1 1'b1;
else det1101 <= #1 1'b0;

assign out = det1101;
endmodule

module test;
reg clock, reset_, D;
wire out;

det1101 U1(clock, reset_, D, out);

initial begin
  $dumpfile("det1101.vcd");
  $dumpvars();
end

//產生時脈，時脈週期=20ns，每半個週期時脈需反相
always #10 
clock = ~clock;

initial begin
#0 clock = 1'b0; reset_ = 1'b0;
#15 reset_ = 1'b1; D = 1'b1;
#37 D = 1'b0;
#20 D = 1'b1;
#58 $finish;
end

always @(out)
$display("%dns out=%d", $time, out);
endmodule

