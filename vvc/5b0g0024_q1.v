// 模組名稱：mult6
// 功能：執行 6 位元無號整數乘法（a × b），結果為 12 位元 axb
module mult6 (
  input  [5:0] a,       // 乘數 a（6 位元）
  input  [5:0] b,       // 被乘數 b（6 位元）
  output [11:0] axb     // 輸出結果 axb（12 位元）
);
  reg [11:0] product;   // 暫存乘積結果
  integer i;            // 迴圈變數

  // 組合邏輯實作「shift and add」乘法器
  always @(*) begin
    product = 0;        // 初始值清零
    for (i = 0; i < 6; i = i + 1) begin
      if (b[i]) begin
        // 如果 b 的第 i 位為 1，則將 a 左移 i 位後加到 product
        product = product + (a << i);
      end
    end
  end

  assign axb = product; // 將乘積指定給輸出
endmodule


// 測試模組：模擬所有 a, b 組合並顯示結果
module test;
  reg [5:0] a, b;         // 測試輸入 a 和 b
  wire [11:0] axb;        // 輸出 axb

  // 實例化乘法器模組
  mult6 U1(a, b, axb);

  // 設定波形輸出檔案（供 gtkwave 使用）
  initial begin
    $dumpfile("vcd/5b0g0024_q1.vcd"); // 指定輸出波形檔名
    $dumpvars();                      // dump 所有變數
  end

  integer i;
  initial begin
    // 測試 6 位元 x 6 位元 所有可能組合（共 4096 次）
    for(i = 0; i < 4096; i = i + 1) begin
      #0 a = i[5:0];      // 取低 6 位給 a
         b = i[11:6];     // 取高 6 位給 b
      #10;                // 模擬間隔 10 ns
    end
    a = 0; b = 0;         // 模擬結束時重設輸入
  end

  // 每次輸入或輸出變動時印出模擬時間與結果
  always @(a or b or axb)
    $display("%d ns, a = %d, b = %d, axb = %d", $time, a, b, axb);

endmodule
