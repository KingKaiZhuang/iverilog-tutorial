//同步計數器
`timescale 1ns/1ns

module count3(clock, reset_, count);
input clock, reset_;
output [2:0] count;

//計數值由0~4
reg [2:0] count;
always @ (posedge clock)
if(~reset_) count <= #1 3'd0;
else if(count==3'd4) count <= #1 3'd0;
else count <= #1 count + 1'b1;

endmodule

module test;
reg clock, reset_;
wire [2:0] count;

count3 U1(clock, reset_, count);

initial begin
  $dumpfile("count3.vcd");
  $dumpvars();
end

//產生時脈，時脈週期=20ns，每半個週期時脈需反相
always #10 
clock = ~clock;

initial begin
#0 clock = 1'b0; reset_ = 1'b0;
#15 reset_ = 1'b1;
#115 $finish;
end

always @(count)
$display("%dns count=%d", $time, count);
endmodule
