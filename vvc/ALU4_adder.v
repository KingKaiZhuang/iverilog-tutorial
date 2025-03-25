`include "vvc/mult4.v"

module ALU4 (A, B, cont, Res);
    input [3:0] A, B;
    input [1:0] cont;
    output [7:0] Res;
    reg [7:0] Res;
    wire [7:0] axb;
    wire [3:0] s;
    wire c;

    mult4 U1(A, B, axb);
    adder4 U2(A, B, s, c);

    always @(A or B or cont)
    case(cont)
    2'b00: Res = {c,s};
    2'b01: Res = axb;
    2'b10: Res = {A / B, A % B};
    2'b11: Res = A & B;
    endcase
endmodule

module test();
    reg [3:0] A, B;
    reg [1:0] cont;
    wire [7:0] Res;

    ALU4 U1(A, B, cont, Res);

    initial begin
        $dumpfile("vcd/ALU4_adder.vcd");
        $dumpvars();
    end    
    integer i;
    initial begin
        #0 A = 4'd3; B = 4'd11;
        for(i = 0; i < 3; i = i + 1) begin
            #0 cont = i;
            #10;
        end
        #10 A = 4'd9; B = 4'd9;
        for(i = 0; i < 3; i = i + 1) begin
            #0 cont = i;
            #10;
        end        
        #10 A = 4'd12; B = 4'd5;
        for(i = 0; i < 3; i = i + 1) begin
            #0 cont = i;
            #10;
        end
        $finish;    // 在设置 A=0, B=0 之前结束仿真
        #0 A = 0; B = 0;
    end

    always @(A or B or cont or Res)
        case(cont)
        2'b00: $display("%d: A = %d, B = %d, A+B = %d\n", $time, A, B, Res);
        2'b01: $display("%d: A = %d, B = %d, A*B = %d\n", $time, A, B, Res);
        2'b10: $display("%d: A = %d, B = %d, A/B = %d, A%%B = %d\n", $time, A, B, Res[7:4], Res[3:0]);
        2'b11: $display("%d: A = %d, B = %d, A&B = %d\n", $time, A, B, Res);
        endcase
endmodule
