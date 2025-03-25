module DFF(clk, rst_, D, Q, Q_);
input clk, rst_, D;
output Q, Q_;
reg Q, Q_;
always @(posedge clk) begin
    if(~rst_) 
        Q <= #1 1'b0;
    else
        Q <= #1 D;
    assign Q_ = ~Q;
end
endmodule