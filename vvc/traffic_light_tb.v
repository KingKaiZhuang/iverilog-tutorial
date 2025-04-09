`timescale 1ns/1ps

`include "vvc/traffic_light.v"
module traffic_light_tb;

reg clk, rst_n;
wire R1, Y1, G1, R2, Y2, G2;

// 例化被測試模組
traffic_light U1 (
    .clk(clk),
    .rst_n(rst_n),
    .R1(R1), .Y1(Y1), .G1(G1),
    .R2(R2), .Y2(Y2), .G2(G2)
);

// 時脈產生器：20ns 一個週期（10ns 正半週，10ns 負半週）
always #10 clk = ~clk;

// 初始條件與測試流程
initial begin
    $dumpfile("vcd/traffic_light_tb.vcd");  // 波形輸出檔案
    $dumpvars(0, traffic_light_tb);  // 儲存所有變數

    clk = 0;
    rst_n = 0;

    #25 rst_n = 1;  // 釋放 reset，在 25ns 時
end

// 模擬觀察時間：模擬完整兩輪 (S0 → S3 → S0 → S3)
initial begin
    #5000;  // 模擬 5000ns
    $finish;
end

// 顯示輸出變化（可選）
always @(posedge clk) begin
    $display("Time=%dns | R1=%b Y1=%b G1=%b | R2=%b Y2=%b G2=%b",
             $time, R1, Y1, G1, R2, Y2, G2);
end

endmodule
