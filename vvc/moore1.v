module moore1(clock, reset_, x, z);
input clock, reset_, x;
output z;
// 宣告狀態
parameter [1:0] S0 = 2'b00, S1 = 2'b01, S2 = 2'b11, S3 = 2'b10;
// 宣告狀態變數目前狀態
reg [1:0] curr_state, next_state;
// 狀態變遷(state transition)，下一個狀態
always @(posedge clock)
if(~reset_) next_state <= #1 S0;
else
  case(curr_state)
    S0: if(x==1'b1) next_state <= #1 S1;
        else next_state <= #1 S3;
    S1: if(x==1'b1) next_state <= #1 S2;
        else next_state <= #1 S0;
    S2: if(x==1'b0) next_state <= #1 S1;
    S3: if(x==1'b1) next_state <= #1 S2;
        else next_state <= #1 S2;
  endcase

always @(next_state)
    curr_state <= #1 next_state;

reg z;
// 由目前狀態決定輸出
always @(curr_state or reset_)
    if(~reset_) z <= #1 1'b0;

    else
      case(curr_state)
      S0, S2: z <= #1 1'b0;
      S1, S3: z <= #1 1'b1;
    endcase
endmodule

module test;
reg clock, reset_, x;
wire z;

moore1 U1(clock, reset_, x, z);

always #10
  clock = ~clock;

initial begin
    $dumpfile("vcd/moore1.vcd");
    $dumpvars();
end

initial begin
    #0 clock=0; reset_=0; x=0;
    #15 reset_=1;
    #100 x=1;
    #100 x=0;
    #100 x=1;
    #100 x=0;
    #100 x=1;
    #100 x=0;
    #100 x=1;
    #100 x=0;
    #100 x=1;
    #100 x=0;
    #100 $finish;
end
endmodule;