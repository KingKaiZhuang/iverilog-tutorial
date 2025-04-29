module traffic_light_controller(
    input clk,          // 時鐘輸入，1毫秒一個脈衝
    input reset,        // 重置信號
    output reg R1, Y1, G1, // 橫行馬路紅綠燈
    output reg R2, Y2, G2  // 直行馬路紅綠燈
);

    // 狀態定義
    parameter S1 = 2'b00; // R1=1, Y1=0, G1=0, R2=0, Y2=0, G2=1 (直行綠燈，橫行紅燈) - 持續20秒
    parameter S2 = 2'b01; // R1=1, Y1=0, G1=0, R2=0, Y2=1, G2=0 (直行黃燈，橫行紅燈) - 持續5秒
    parameter S3 = 2'b10; // R1=0, Y1=0, G1=1, R2=1, Y2=0, G2=0 (直行紅燈，橫行綠燈) - 持續20秒
    parameter S4 = 2'b11; // R1=0, Y1=1, G1=0, R2=1, Y2=0, G2=0 (直行紅燈，橫行黃燈) - 持續5秒

    // 計數器和狀態寄存器
    reg [1:0] state;       // 當前狀態
    reg [14:0] counter;    // 計數器，最大可計數到32767ms

    // 狀態轉換和計數邏輯
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // 重置到初始狀態
            state <= S1;
            counter <= 0;
        end else begin
            case (state)
                S1: begin
                    // 第一個狀態持續20秒
                    if (counter >= 20000 - 1) begin  // 20000ms = 20秒
                        state <= S2;
                        counter <= 0;
                    end else begin
                        counter <= counter + 1;
                    end
                end
                
                S2: begin
                    // 第二個狀態持續5秒
                    if (counter >= 5000 - 1) begin  // 5000ms = 5秒
                        state <= S3;
                        counter <= 0;
                    end else begin
                        counter <= counter + 1;
                    end
                end
                
                S3: begin
                    // 第三個狀態持續20秒
                    if (counter >= 20000 - 1) begin
                        state <= S4;
                        counter <= 0;
                    end else begin
                        counter <= counter + 1;
                    end
                end
                
                S4: begin
                    // 第四個狀態持續5秒
                    if (counter >= 5000 - 1) begin
                        state <= S1;  // 回到第一個狀態，完成循環
                        counter <= 0;
                    end else begin
                        counter <= counter + 1;
                    end
                end
                
                default: begin
                    // 異常狀態處理
                    state <= S1;
                    counter <= 0;
                end
            endcase
        end
    end

    // 根據當前狀態輸出燈號控制信號
    always @(state) begin
        case (state)
            S1: begin
                // 直行綠燈，橫行紅燈
                R1 = 1; Y1 = 0; G1 = 0;
                R2 = 0; Y2 = 0; G2 = 1;
            end
            
            S2: begin
                // 直行黃燈，橫行紅燈
                R1 = 1; Y1 = 0; G1 = 0;
                R2 = 0; Y2 = 1; G2 = 0;
            end
            
            S3: begin
                // 直行紅燈，橫行綠燈
                R1 = 0; Y1 = 0; G1 = 1;
                R2 = 1; Y2 = 0; G2 = 0;
            end
            
            S4: begin
                // 直行紅燈，橫行黃燈
                R1 = 0; Y1 = 1; G1 = 0;
                R2 = 1; Y2 = 0; G2 = 0;
            end
            
            default: begin
                // 異常狀態處理，所有燈都設為紅燈
                R1 = 1; Y1 = 0; G1 = 0;
                R2 = 1; Y2 = 0; G2 = 0;
            end
        endcase
    end

endmodule

// 測試模塊
module traffic_light_controller_tb;
    // 定義輸入和輸出
    reg clk;
    reg reset;
    wire R1, Y1, G1;
    wire R2, Y2, G2;
    
    // 時間變量
    integer ms_counter;
    reg [31:0] seconds; // 用於顯示的秒數計數器
    
    // 實例化控制器
    traffic_light_controller uut (
        .clk(clk),
        .reset(reset),
        .R1(R1), .Y1(Y1), .G1(G1),
        .R2(R2), .Y2(Y2), .G2(G2)
    );
    
    // 生成時鐘信號 - 1毫秒一個周期
    always #0.5 clk = ~clk;
    
    // 計算秒數（修正$monitor錯誤）
    always @(posedge clk) begin
        if (reset) begin
            ms_counter <= 0;
            seconds <= 0;
        end else begin
            ms_counter <= ms_counter + 1;
            if (ms_counter % 1000 == 0) begin
                seconds <= ms_counter / 1000;
                $display("時間: %0d 秒", seconds);
                $display("橫行馬路: R1=%b Y1=%b G1=%b", R1, Y1, G1);
                $display("直行馬路: R2=%b Y2=%b G2=%b", R2, Y2, G2);
                $display("------------------------");
            end
        end
    end
    
    // 使用$monitor只監視燈號的變化
    initial begin
        $monitor("燈號狀態變化 - 橫行: R1=%b Y1=%b G1=%b, 直行: R2=%b Y2=%b G2=%b", 
                 R1, Y1, G1, R2, Y2, G2);
    end
    
    // 測試序列
    initial begin
        // 初始化
        clk = 0;
        reset = 1;
        ms_counter = 0;
        seconds = 0;
        
        // 釋放復位
        #10 reset = 0;
        
        // 運行足夠長的時間來觀察一個完整循環
        #55000;  // 55秒 = 20秒+5秒+20秒+5秒+5秒（額外運行5秒）
        
        // 結束模擬
        $finish;
    end
    
    // 保存波形文件（如果支持）
    initial begin
        $dumpfile("vcd/5b0g0024_q4.vcd");
        $dumpvars(0, traffic_light_controller_tb);
    end
    
endmodule