module moore_det1101(clk, rst_, D, out);
input clk, rst_, D;
output out;
// 宣告狀態
parameter [2:0] SIDLE = 3'b000, S1 = 3'b001, S11 = 3'b010,
                S110 = 3'b011, S1101 = 3'b100;
reg [2:0] curr_state, next_state;

// 狀態轉移表
// 目前狀態(curr_state)   輸入(D)     下一狀態(next_state)
// SIDLE                 0           SIDLE
// SIDLE                 1           S1
// S1                    0           SIDLE
// S1                    1           S11
// S11                   0           S110
// S11                   1           S11
// S110                  0           SIDLE
// S110                  1           S1101
// S1101                 0           SIDLE
// S1101                 1           S11
// default               x           SIDLE

always @(posedge clk)
    if(~rst_) next_state <= #1 S0;
    else
        case(curr_state)
            SIDLE:
                if(D==1'b1) next_state <= #1 S1;
            S1:
                if(D==1'b1) next_state <= #1 S11;
                else next_state <= #1 SIDLE;
            S11:
                if(D==1'b0) next_state <= #1 S110;
            S110:
                if(D==1'b1) next_state <= #1 S1101;
                else next_state <= #1 SIDLE;
            S1101:
                if(D==1'b1) next_state <= #1 S11;
                else next_state <= #1 SIDLE;
            default:
                next_state <= #1 SIDLE;
        endcase

// 由下一狀態改變目前狀態
always @(next_state or rst_)
    if(~rst_) curr_state <= #1 SIDLE;
    else
        curr_state <= #1 next_state;

reg out;
// 由目前狀態決定輸出
always @(curr_state or rst_)
    if(~rst_) out <= #1 1'b0;
    else
        case(curr_state)
            S1101: begin out <= #1 1'b1; end
            default: out <= #1 1'b0;
        endcase

endmodule

module test;
reg clock, reset_, D;
wire out;

moore_det1101 U1(clock, reset_, D, out);

initial begin
    $dumpfile("vcd/moore_det1101.vcd");
    $dumpvars();
end

// 產生時脈，時脈週期 = 20ns，每半個週期時脈需反相
always #10
    clock = ~clock;

initial begin
    #0  clock = 1'b0; reset_ = 1'b0;
    #15 reset_ = 1'b1; D = 1'b1;
    #37 D = 1'b0;
    #20 D = 1'b1;
    #58 $finish;
end

always @(out)
    $display("%dns out=%d", $time, out);

endmodule
