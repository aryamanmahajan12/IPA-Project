`timescale 1ns / 1ps

`include "ALU.v"

module execute(clk,icode,ifun,valA,valB,valC,valE,Cnd,ZF,SF,OF);

input  clk;
input [3:0] icode;
input  [3:0] ifun;
input signed [63:0] valA;
input signed [63:0] valB;
input signed [63:0] valC;

output reg signed [63:0] valE; 
output reg Cnd;

output reg ZF,SF,OF;

initial 
begin
    ZF=0;
    SF=0;
    OF=0;
end

always@(*)
begin
if(clk==1 && icode==4'b0110)
begin
    ZF=(ALU_Op == 1'b0);
    SF=(ALU_Op[63] == 1'b1);
    OF=(ALU_Ip_1<1'b0 == ALU_Ip_2<1'b0) && (ALU_Op<1'b0 != ALU_Ip_1<1'b0);
end
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
    if(clk==1)
    begin
        Cnd=0;

        if(icode==4'b0010) //cmovxx
        begin
                
            if(ifun==4'b0000)//rrmovq
            begin
                Cnd=1;
            end
            
            else if(ifun==4'b0001)//cmovle
            begin
                if((SF^OF)||ZF)
                begin
                Cnd=1;
                end
            end
            else if(ifun==4'b0010)//cmovl
            begin
                if(SF^OF)
                begin
                Cnd=1;
                end
            end
            else if(ifun==4'b0011)//cmove
            begin
                if(ZF)
                begin
                Cnd=1;
                end
            end
            else if(ifun==4'b0100)//cmovne
            begin
                if(!ZF)
                begin
                Cnd=1;
                end
            end
            else if(ifun==4'b0101)//cmovge
            begin
                if(!(SF^OF))
                begin
                Cnd=1;
                end
            end
            else if(ifun==4'b0110)//cmovg
            begin
                if(!((SF^OF)||ZF))
                begin
                Cnd=1;
                end
            end

            //valE=64'd0+valA;
            Ctrl=2'b00;
            ALU_Ip_1 = valA;
            ALU_Ip_2 = 64'b0;
            valE = ALU_Op;  
        end

        else if(icode==4'b0011) //irmovq
        begin
            //valE=64'd0+valC;
            ALU_Ip_1 = valC;
            ALU_Ip_2 = 64'b0;
            valE = ALU_Op;  
        end

        else if(icode==4'b0100 || icode==4'b0101) //rmmovq & mrmovq
        begin
            //valE=valB+valC;
            ALU_Ip_1 = valB;
            ALU_Ip_2 = valC;
            valE = ALU_Op;  
        end

        else if(icode==4'b0110) //OPq
        begin
            if(ifun==4'b0000) //add
            begin
                //valE = valA + valB;
                Ctrl=2'b00;
            end
            else if(ifun==4'b0001) //sub
            begin
                //valE = valA - valB;
                Ctrl=2'b01;
            end
            else if(ifun==4'b0010) //and
            begin
                //valE = valA & valB;
                Ctrl=2'b10;
            end
            else if(ifun==4'b0011) //xor
            begin
                //valE = valA ^ valB;
                Ctrl=2'b11;
            end

            ALU_Ip_1 = valA;
            ALU_Ip_2 = valB;
            valE = ALU_Op;

        end

        if(icode==4'b0111) //jxx
        begin
            if(ifun==4'b0000)//jmp
            begin
                Cnd=1;
            end
            else if(ifun==4'b0001)//jle
            begin
                if((SF^OF)||ZF)
                begin
                Cnd=1;
                end
            end
            else if(ifun==4'b0010)//jl
            begin
                if(SF^OF)
                begin
                Cnd=1;
                end
            end
            else if(ifun==4'b0011)//je
            begin
                if(ZF)
                begin
                Cnd=1;
                end
            end
            else if(ifun==4'b0100)//jne
            begin
                if(!ZF)
                begin
                Cnd=1;
                end
            end
            else if(ifun==4'b0101)//jge
            begin
                if(!(SF^OF))
                begin
                Cnd=1;
                end
            end
            else if(ifun==4'b0110)//jg
            begin
                if(!((SF^OF)||ZF))
                begin
                Cnd=1;
                end
            end  
        end

        if(icode==4'b1000 || icode==4'b1010) //call & pushq
        begin
            //valE= valB - 8;
            Ctrl = 2'b01;
            ALU_Ip_1 = valB;
            ALU_Ip_2 = 64'd8;
             valE = ALU_Op;
        end

        if(icode==4'b1001  || icode==4'b1011) //ret &  popq
        begin
            //valE = valB + 8;
            Ctrl = 2'b00;
            ALU_Ip_1 = valB;
            ALU_Ip_2 = 64'd8;
             valE = ALU_Op;
        end
    end
end

endmodule