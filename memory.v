`timescale 1ns / 1ps

module memory(
clk,
M_stat, M_icode,M_valE,M_valA,M_dstE,M_dstM,M_cnd,
m_stat,m_valE,m_valM, memdata
);

input clk, M_cnd;
input [2:0] M_stat;
input [3:0] M_icode;
input [63:0] M_valA, M_valE;
input [3:0] M_dstE, M_dstM; 

output reg [2:0] m_stat;
output reg [63:0] m_valM, m_valE;

reg [63:0] mem[0:4095];
reg dmem_err = 0;
output reg [63:0] memdata;


always@(*)
begin
    if(M_icode==4'b1001)//ret
begin
    m_valM=mem[M_valA];
    if(M_valA>4095)
    begin
        dmem_err = 1'b1;
    end
end

    else if(M_icode==4'b0101)//mrmov
    begin
        m_valM = mem[M_valE];
        if(M_valE>4095)
        begin
            dmem_err = 1'b1;
        end
    end

    else if(M_icode == 4'b1011)//pop
    begin
        m_valM = mem[M_valA];
        if(M_valA>4095)
        begin
            dmem_err = 1'b1;
        end
    end


else if(M_icode==4'b0100)//rmmov
begin
    mem[M_valE] = M_valA;
    if(M_valE>4095)
    begin
        dmem_err = 1'b1;
    end
end

else if(M_icode == 4'b1010)//push
begin
    mem[M_valE] = M_valA;
    if(M_valE>4095)
    begin
        dmem_err = 1'b1;
    end
end

else if(M_icode == 4'b1000)//call
begin
    mem[M_valE] = M_valA;
    if(M_valE>4095)
    begin
        dmem_err = 1'b1;
    end
end

    m_valE <= M_valE;
    memdata = mem[M_valE];
end

always@(*)
begin

if(dmem_err) 
    m_stat = 3;
    else
    m_stat = M_stat;

end

endmodule