//`timescale 1ns / 1ps

`include "ALU.v"

// doubt : m_stat==0 && W_stat==0
// -8 doubt (is complement acceptable in decimal signed form)
// rnone = r1111

module execute(
clk,
E_icode,E_ifun,E_stat,E_valC,E_valA,E_valB,E_srcA,E_srcB,E_dstE,E_dstM,
m_stat,W_stat,
e_valE,e_valA,e_cnd,e_dstE
);

output reg [63:0] e_valA, e_valE;
output reg [3:0] e_dstE;
output reg e_cnd;

input wire [2:0] E_stat,W_stat,m_stat;
input wire clk;
input wire [3:0] E_icode,E_ifun,E_srcA,E_srcB,E_dstE, E_dstM;
input wire [63:0] E_valC,E_valA,E_valB;

reg ZF,SF,OF;

initial
begin
    ZF=0;
    SF=0;
    OF=0;
end

reg [1:0]Ctrl;
reg signed [63:0]ALU_Ip_1;
reg signed [63:0]ALU_Ip_2;

wire signed [63:0]ALU_Op;
wire ALU_OF;

ALU64 ALU_1(
.Ctrl(Ctrl),
.A(ALU_Ip_1),
.B(ALU_Ip_2),
.O(ALU_Op),
.OF(ALU_OF)
);

initial
begin
Ctrl=2'b00;
ALU_Ip_1 = 64'b0;
ALU_Ip_2 = 64'b0;
end

always@(*)
begin
if(clk==1 && E_icode==4'b0110 && m_stat==3'b001 && W_stat==3'b001)
begin
    ZF=(ALU_Op == 1'b0);
    SF=(ALU_Op[63] == 1'b1);
    OF=((ALU_Ip_1[63]==1'b1) == (ALU_Ip_2[63]==1'b1)) && ((ALU_Op[63]==1'b1) != (ALU_Ip_1[63]==1'b1));
end
end


always @(*)
begin

e_valA = E_valA;
e_dstE = E_dstE;

e_cnd=0;

if(E_icode==4'b0010) //cmovxx
begin
        
    if(E_ifun==4'b0000)//rrmovq
    begin
        e_cnd=1;
    end
    
    else if(E_ifun==4'b0001)//cmovle
    begin
        if((SF^OF)||ZF)
        begin
        e_cnd=1;
        end
    end
    else if(E_ifun==4'b0010)//cmovl
    begin
        if(SF^OF)
        begin
        e_cnd=1;
        end
    end
    else if(E_ifun==4'b0011)//cmove
    begin
        if(ZF)
        begin
        e_cnd=1;
        end
    end
    else if(E_ifun==4'b0100)//cmovne
    begin
        if(!ZF)
        begin
        e_cnd=1;
        end
    end
    else if(E_ifun==4'b0101)//cmovge
    begin
        if(!(SF^OF))
        begin
        e_cnd=1;
        end
    end
    else if(E_ifun==4'b0110)//cmovg
    begin
        if(!((SF^OF)||ZF))
        begin
        e_cnd=1;
        end
    end

    // e_valE = 64'd0 + E_valA;
    Ctrl=2'b00;
    ALU_Ip_1 = E_valA;
    ALU_Ip_2 = 64'b0;
    e_valE = ALU_Op; 

    if(e_cnd == 0)
        e_dstE = 4'b1111;

end

else if(E_icode==4'b0011) //irmovq
begin
    //e_valE=64'd0+e_valC;
    ALU_Ip_1 = E_valC;
    ALU_Ip_2 = 64'b0;
    e_valE = ALU_Op;  
end

else if(E_icode==4'b0100 || E_icode==4'b0101) //rmmovq & mrmovq
begin
    //e_valE=e_valB+e_valC;
    ALU_Ip_1 = E_valC;
    ALU_Ip_2 = E_valB;
    e_valE = ALU_Op;  
end

else if(E_icode==4'b0110) //OPq
begin
    if(E_ifun==4'b0000) //add
    begin
        //e_valE = e_valA + e_valB;
        Ctrl=2'b00;
    end
    else if(E_ifun==4'b0001) //sub
    begin
        //e_valE = e_valA - e_valB;
        Ctrl=2'b01;
    end
    else if(E_ifun==4'b0010) //and
    begin
        //e_valE = e_valA & e_valB;
        Ctrl=2'b10;
    end
    else if(E_ifun==4'b0011) //xor
    begin
        //e_valE = e_valA ^ e_valB;
        Ctrl=2'b11;
    end
    else
    begin
        Ctrl=2'b00;
    end

    ALU_Ip_1 = E_valA;
    ALU_Ip_2 = E_valB;
    e_valE = ALU_Op;

end

if(E_icode==4'b0111) //jxx
begin
    if(E_ifun==4'b0000)//jmp
    begin
        e_cnd=1;
    end
    else if(E_ifun==4'b0001)//jle
    begin
        if((SF^OF)||ZF)
        begin
        e_cnd=1;
        end
    end
    else if(E_ifun==4'b0010)//jl
    begin
        if(SF^OF)
        begin
        e_cnd=1;
        end
    end
    else if(E_ifun==4'b0011)//je
    begin
        if(ZF)
        begin
        e_cnd=1;
        end
    end
    else if(E_ifun==4'b0100)//jne
    begin
        if(!ZF)
        begin
        e_cnd=1;
        end
    end
    else if(E_ifun==4'b0101)//jge
    begin
        if(!(SF^OF))
        begin
        e_cnd=1;
        end
    end
    else if(E_ifun==4'b0110)//jg
    begin
        if(!((SF^OF)||ZF))
        begin
        e_cnd=1;
        end
    end  
end

if(E_icode==4'b1000 || E_icode==4'b1010) //call & pushq
begin
    //e_valE= e_valB - 8;
    Ctrl = 2'b00;
    ALU_Ip_1 = -8;
    ALU_Ip_2 = E_valB;
    e_valE = ALU_Op;
end

if(E_icode==4'b1001  || E_icode==4'b1011) //ret &  popq
begin
    //e_valE = e_valB + 8;
    Ctrl = 2'b00;
    ALU_Ip_1 = 64'd8;
    ALU_Ip_2 = E_valB;
    e_valE = ALU_Op;
end

end

endmodule