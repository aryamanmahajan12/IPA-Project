module execute_reg(clk,
E_bubble,
D_stat,D_icode,D_ifun,d_valA,d_valB,D_valC,d_srcA,d_srcB,d_dstE,d_dstM,
E_stat,E_icode,E_ifun,E_valA,E_valB,E_valC,E_srcA,E_srcB,E_dstE,E_dstM);


input wire clk,E_bubble;

input wire [2:0] D_stat;
input wire [3:0] D_icode,D_ifun,d_srcA,d_srcB,d_dstE,d_dstM;
input wire [63:0] d_valA,d_valB,D_valC;

output reg [2:0] E_stat;
output reg [3:0] E_icode,E_ifun,E_srcA,E_srcB,E_dstE,E_dstM;
output reg [63:0] E_valA,E_valB,E_valC;

always@(posedge clk)
begin

    if(!(E_bubble))
    begin
        E_stat  <= D_stat;
        E_icode <= D_icode;
        E_ifun <= D_ifun;
        E_valC <= D_valC;
        E_valA <= d_valA;
        E_valB <= d_valB;
        E_dstE <= d_dstE;
        E_dstM <= d_dstM;
        E_srcA <= d_srcA;
        E_srcB <= d_srcB;
    end

    else
    begin
        
        E_stat  <= 1;
        E_icode <= 4'b0001;
        E_ifun <= 4'b0000;
    end
end



endmodule