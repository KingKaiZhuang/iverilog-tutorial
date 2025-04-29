`timescale 1ns/1ns

// 8位元 上數計數器：計數範圍 0~119，並有一輸出訊號 out 在 count > 49 時為 1
module count8 (
  input clock,
  input reset_,
  output reg [7:0] count,
  output wire out
);

// 計數邏輯：同步於 clock 上升沿
always @(posedge clock) begin
  if (~reset_) begin
    count <= #1 8'd0;             // 當 reset_ 為 0，計數器清零
  end else if (count == 8'd119) begin
    count <= #1 8'd0;             // 當 count 達 119，重設為 0
  end else begin
    count <= #1 count + 1'b1;     // 其他情況下每次加 1
  end
end

// 當 count > 49 時，輸出 out = 1；否則 out = 0
assign out = (count > 8'd49) ? 1'b1 : 1'b0;

endmodule


// 測試模組
module test;
  reg clock, reset_;
  wire [7:0] count;
  wire out;

  // 實例化 8 位元計數器
  count8 U1(clock, reset_, count, out);

  // 產生 VCD 波形檔供 gtkwave 使用
  initial begin
    $dumpfile("5b0g0024_q2.vcd");
    $dumpvars();
  end

  // 產生時脈：週期為 20ns（每 10ns 反轉）
  always #10 clock = ~clock;

  // 初始條件設定
  initial begin
    #0  clock = 1'b0; 
        reset_ = 1'b0;
    #15 reset_ = 1'b1;    // 15ns 時釋放 reset_
    #2500 $finish;        // 模擬 2500ns，足以觀察完整循環
  end

  // 當 count 有變化時印出訊息
  always @(count)
    $display("%dns count=%d, out=%b", $time, count, out);
endmodule
