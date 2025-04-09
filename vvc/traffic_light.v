module traffic_light (
    input clk,
    input rst_n,
    output reg R1, Y1, G1,  // 橫向
    output reg R2, Y2, G2   // 直向
);

    // 狀態定義
    parameter S0 = 2'b00, // R1=1, R2=0, G2=1
              S1 = 2'b01, // R1=1, R2=0, Y2=1
              S2 = 2'b10, // R1=0, G1=1, R2=1
              S3 = 2'b11; // R1=0, Y1=1, R2=1

    reg [1:0] state;
    reg [6:0] counter;

    // 狀態轉移邏輯
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S0;
            counter <= 0;
        end else begin
            case (state)
                S0: begin
                    if (counter == 7'd99) begin
                        state <= S1;
                        counter <= 0;
                    end else
                        counter <= counter + 1;
                end
                S1: begin
                    if (counter == 7'd19) begin
                        state <= S2;
                        counter <= 0;
                    end else
                        counter <= counter + 1;
                end
                S2: begin
                    if (counter == 7'd99) begin
                        state <= S3;
                        counter <= 0;
                    end else
                        counter <= counter + 1;
                end
                S3: begin
                    if (counter == 7'd19) begin
                        state <= S0;
                        counter <= 0;
                    end else
                        counter <= counter + 1;
                end
            endcase
        end
    end

    // 狀態輸出（Moore）
    always @(*) begin
        // 預設全部關閉
        R1 = 0; Y1 = 0; G1 = 0;
        R2 = 0; Y2 = 0; G2 = 0;

        case (state)
            S0: begin
                R1 = 1; G2 = 1;
            end
            S1: begin
                R1 = 1; Y2 = 1;
            end
            S2: begin
                R2 = 1; G1 = 1;
            end
            S3: begin
                R2 = 1; Y1 = 1;
            end
        endcase
    end

endmodule
