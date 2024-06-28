module writeback_reg(clk,W_stall,M_icode,M_valE,M_dstE,M_dstM,m_stat,m_valM,W_stat,W_icode,W_valE,W_valM,W_dstE,W_dstM);

input wire clk;

input wire W_stall;

input wire [3:0] M_icode;
input wire [63:0] M_valE;
input wire [3:0] M_dstE;
input wire [3:0] M_dstM;

input wire [2:0] m_stat;

input wire [63:0] m_valM;

output reg [2:0] W_stat;

output reg [3:0] W_icode;
output reg [63:0] W_valE;
output reg [63:0] W_valM;
output reg [3:0] W_dstM;
output reg [3:0] W_dstE;


always @(posedge clk)
begin
    if(!W_stall)
    begin
        W_icode <= M_icode;
        W_valE <=  M_valE;
        W_dstE <= M_dstE;
        W_dstM <= M_dstM;
        W_stat <= m_stat;
        W_valM <= m_valM;
    end
end


endmodule