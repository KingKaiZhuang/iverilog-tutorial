`timescale 1ns/1ns
module moore_det100110(clk, rst_, D, out);
input clk, rst_, D;
output reg out;

// 宣告狀態
parameter [2:0]
  SIDLE    = 3'b000,
  S1       = 3'b001,
  S10      = 3'b010,
  S100     = 3'b011,
  S1001    = 3'b100,
  S10011   = 3'b101,
  S100110  = 3'b110;

// 宣告目前狀態與下一狀態變數
reg [2:0] curr_state, next_state;

// 狀態轉移條件判斷（同步邏輯）
always @(posedge clk)
  if (~rst_)
    next_state <= #1 SIDLE;
  else
    case (curr_state)
      SIDLE:     if (D == 1'b1) next_state <= #1 S1;
                 else next_state <= #1 SIDLE;

      S1:        if (D == 1'b0) next_state <= #1 S10;
                 else next_state <= #1 S1;

      S10:       if (D == 1'b0) next_state <= #1 S100;
                 else next_state <= #1 S1;

      S100:      if (D == 1'b1) next_state <= #1 S1001;
                 else next_state <= #1 SIDLE;

      S1001:     if (D == 1'b1) next_state <= #1 S10011;
                 else next_state <= #1 S10;

      S10011:    if (D == 1'b0) next_state <= #1 S100110;
                 else next_state <= #1 S1;

      S100110:   if (D == 1'b1) next_state <= #1 S1;     // 可重疊偵測
                 else next_state <= #1 S10;

      default:   next_state <= #1 SIDLE;
    endcase

// 狀態更新
always @(next_state or rst_)
  if (~rst_)
    curr_state <= #1 SIDLE;
  else
    curr_state <= #1 next_state;

// Moore 狀態輸出
always @(curr_state or rst_)
  if (~rst_)
    out <= #1 1'b0;
  else
    case (curr_state)
      S100110: out <= #1 1'b1;
      default: out <= #1 1'b0;
    endcase

endmodule

// 測試模組
module test;
reg clock, reset_, D;
wire out;

moore_det100110 U1(clock, reset_, D, out);

initial begin
  $dumpfile("5b0g0024_q3.vcd");
  $dumpvars();
end

// 產生時脈，週期 20ns（每 10ns 反轉）
always #10 clock = ~clock;

// 測試輸入序列：100110
initial begin
  #0  clock = 0; reset_ = 0; D = 0;
  #15 reset_ = 1;
  #20 D = 1; // S1
  #20 D = 0; // S10
  #20 D = 0; // S100
  #20 D = 1; // S1001
  #20 D = 1; // S10011
  #20 D = 0; // S100110 → 應該輸出 1
  #20 D = 1; // 可重疊，進入 S1
  #40 $finish;
end

// 印出 out 的變化
always @(out)
  $display("%dns out=%d", $time, out);
endmodule
