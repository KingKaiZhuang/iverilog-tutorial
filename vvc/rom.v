module rom16(addr, data);
input [3:0] addr;
output reg [3:0] data;

always @(*) begin
    case(addr)
        4'd0: data = #1 4'd0;
        4'd1: data = #1 4'd1;
        4'd2: data = #1 4'd2;
        4'd3: data = #1 4'd3;
        4'd4: data = #1 4'd4;
        4'd5: data = #1 4'd5;
        4'd6: data = #1 4'd6;
        4'd7: data = #1 4'd7;
        4'd8: data = #1 4'd8;
        4'd9: data = #1 4'd9;
        4'd10: data = #1 4'd10;
        4'd11: data = #1 4'd11;
        4'd12: data = #1 4'd12;
        4'd13: data = #1 4'd13;
        4'd14: data = #1 4'd14;
        4'd15: data = #1 4'd15;
    endcase
end
endmodule

module test;
reg [3:0] addr;
wire [3:0] data;
integer i;

rom16 U1(addr, data);

initial begin
    $dumpfile("vcd/rom.vcd");
    $dumpvars();
end

initial begin
    for(i=0; i<16; i=i+1) begin
        addr = i;
        #10;
    end
end

always @(*) begin
    $display("%d ns, addr = %d, rom data = %d", $time, addr, data);
end
endmodule