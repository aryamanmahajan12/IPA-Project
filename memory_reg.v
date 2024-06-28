module mem_reg (
    clk,M_bubble,
    E_icode,E_stat,e_valE,e_valA,e_cnd,e_dstE,E_dstM,
    M_icode,M_stat,M_valE,M_valA,M_cnd,M_dstE,M_dstM
    );

input clk;
input e_cnd;
input [2:0] E_stat;
input [3:0] E_icode, e_dstE, E_dstM;
input [63:0] e_valA, e_valE;

input  M_bubble;
output reg M_cnd;
output reg [2:0] M_stat;
output reg [3:0] M_icode, M_dstE, M_dstM; 
output reg [63:0] M_valE, M_valA;

always @(posedge clk)
    begin

        if(!M_bubble)
        begin
            M_stat <= E_stat;
            M_cnd <= e_cnd;
            M_icode <= E_icode;
            M_valA <= e_valA;
            M_valE <= e_valE;
            M_dstE <= e_dstE;
            M_dstM <= E_dstM;
        end
        else
        begin
            M_stat <= 0;
            M_cnd <= 0;
            M_icode <= 4'b0001;
        end

    end
endmodule