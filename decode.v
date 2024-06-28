module decode(
  clk,D_bubble,
  D_stat,D_icode,D_ifun,D_rA,D_rB,D_valC,D_valP,
  e_dstE,e_valE,M_dstE,M_valE,M_dstM,m_valM,W_dstM,W_valM,W_dstE,W_valE,
  W_stat,W_icode,
  d_valA,d_valB,d_srcA,d_srcB,d_dstE,d_dstM,
  reg_bank0,reg_bank1,reg_bank2,reg_bank3,reg_bank4,
  reg_bank5,reg_bank6,reg_bank7,reg_bank8,reg_bank9,reg_bank10,reg_bank11,reg_bank12,reg_bank13,reg_bank14,reg_bank15
  );

// what exactly does R_none mean ??
//for now, we set rnone to F. and now we are using , 16 registers again.

input wire clk,D_bubble;
input wire [2:0] D_stat, W_stat;
input wire [3:0] D_icode, W_icode;
input wire [3:0] D_ifun,D_rA,D_rB;
input wire [63:0] D_valC,D_valP;

input wire [3:0] e_dstE,M_dstE,M_dstM,W_dstE,W_dstM;
input wire [63:0] e_valE,M_valE,m_valM,W_valE,W_valM;

//input wire cnd;

output reg [63:0] d_valA;
output reg [63:0] d_valB;
output reg [3:0]  d_srcA,d_srcB,d_dstE,d_dstM;


output reg [63:0] reg_bank0;
output reg [63:0] reg_bank1;
output reg [63:0] reg_bank2;
output reg [63:0] reg_bank3;
output reg [63:0] reg_bank4;
output reg [63:0] reg_bank5;
output reg [63:0] reg_bank6;
output reg [63:0] reg_bank7;
output reg [63:0] reg_bank8;
output reg [63:0] reg_bank9;
output reg [63:0] reg_bank10;
output reg [63:0] reg_bank11;
output reg [63:0] reg_bank12;
output reg [63:0] reg_bank13;
output reg [63:0] reg_bank14;
output reg [63:0] reg_bank15;


reg [63:0] reg_bank[0:15];



initial
begin

    reg_bank[0] =0;
    reg_bank[1] =0;
    reg_bank[2] =0;
    reg_bank[3] =0;
    reg_bank[4] =4095;
    reg_bank[5] =0;
    reg_bank[6] =0;
    reg_bank[7] =0;
    reg_bank[8] =0;
    reg_bank[9] =0;
    reg_bank[10]=0;
    reg_bank[11]=0;
    reg_bank[12]=0;
    reg_bank[13]=0;
    reg_bank[14]=0;
    reg_bank[15]=0;

end


always @(*)
begin 

//a slightly shorter route has been implemented here.
//instead of formalising a d_srcA, we have directly read the
//values into d_valA.
//based on forwarding conditions, we did  other changes


if(D_icode == 4'b0010)//cmov
begin
  d_srcA=D_rA;
  d_dstE = D_rB;

  d_valA=reg_bank[D_rA];
  d_valB=reg_bank[D_rB];
end

else if(D_icode == 4'b0011)//irmov
begin

  d_dstE = D_rB;


  d_valA=4'b1111;
  d_valB=reg_bank[D_rB];
end

else if(D_icode == 4'b0100)//rmmov
begin
    d_srcA=D_rA;
    d_srcB=D_rB;


  d_valA=reg_bank[D_rA];
  d_valB=reg_bank[D_rB];  
end

else if(D_icode == 4'b0101)//mrmov
begin
    d_srcB=D_rB;
    d_dstM=D_rA;

  d_valA=reg_bank[D_rA];
  d_valB=reg_bank[D_rB];   
end

else if(D_icode == 4'b0110)//op
begin
    d_srcA=D_rA;
    d_srcB=D_rB;
    d_dstE = D_rB;

   d_valA= reg_bank[D_rA];
   d_valB= reg_bank[D_rB];   
end

else if(D_icode == 4'b1010)//push
begin 
    d_srcA=D_rA;
    d_srcB=4;
    d_dstE = 4;

   d_valA =  reg_bank[D_rA];
   d_valB = reg_bank[4];
end

//For jump and call, d_valA becomes the valP

else if(D_icode == 4'b0111)//jump
begin 
   d_valA = D_valP;
   d_valB = reg_bank[4];
end


//For jump and call, d_valA becomes the valP

else if(D_icode == 4'b1000)//call
begin
   d_srcB = 4;
   d_dstE = 4;

   d_valA = D_valP;
   d_valB = reg_bank[4];   
end

else if(D_icode == 4'b1011 || D_icode == 4'b1001)//pop & ret
begin 

    d_srcA=4;
    d_srcB=4;
    d_dstE = 4;

if(D_icode == 4'b1011)
begin
  d_dstM=D_rA;
end

   d_valA=reg_bank[4]; 
   d_valB=reg_bank[4]; 
end

else
begin
  d_valA=0;
  d_valB=0;
  d_srcA = 4'b1111;
  d_srcB = 4'b1111;
  d_dstE = 4'b1111;
  d_dstM = 4'b1111;
end

if(D_icode==4'b1000 || D_icode==4'b0111)
d_valA = D_valP;

else if(d_srcA==e_dstE)
begin
     d_valA= e_valE;
end

else if(d_srcA ==M_dstM)
begin
    d_valA= m_valM;
end

else if(d_srcA==M_dstE)
begin
    d_valA= M_valE;
end

else if(d_srcA==W_dstM)
begin
    d_valA= W_valM;
end

else if(d_srcA == W_dstE)
begin
    d_valA= W_valE;
end


//-------

if(d_srcB==e_dstE)
begin
     d_valB= e_valE;
end

if(d_srcB ==M_dstM)
begin
    d_valB= m_valM;
end

 if(d_srcB==M_dstE)
begin
    d_valB= M_valE;
end

 if(d_srcB==W_dstM)
begin
    d_valB= W_valM;
end

 if(d_srcB== W_dstE)
begin
    d_valB= W_valE;
end

end

always @(*)
begin
    
    if(W_icode == 4'b0010)//cmov
    begin    
        reg_bank[W_dstE] = W_valE;
    end
    
    else if(W_icode ==4'b0011)//irmov
    begin
    //we have rB basically. And we need valC.
    reg_bank[W_dstE] = W_valE;
    end
    
    else if(W_icode ==4'b0100)//rmmov
    begin
    //nothing to be done really
    end
    
    else if(W_icode ==4'b0101)//mrmov
    begin    
    reg_bank[W_dstM]=W_valM;
    end
    
    else if(W_icode ==4'b0110)//op
    begin
    reg_bank[W_dstE]=W_valE;
    end

    else if(W_icode ==4'b1010)//push
    begin
    //reg_bank[4] = reg_bank[4]-64'd8;
    reg_bank[4]=W_valE;
    end

    else if(W_icode ==4'b1011)//pop
    begin
    //reg_bank[4] = reg_bank[4]+64'd8;
    reg_bank[W_dstE] = W_valE;
    reg_bank[W_dstM] = W_valM;
    end

    else if(W_icode ==4'b1000 || W_icode ==4'b1001)//call & ret
    begin
        reg_bank[4]=W_valE;
    end


    reg_bank0  =reg_bank[0];
    reg_bank1  =reg_bank[1];
    reg_bank2  =reg_bank[2];
    reg_bank3  =reg_bank[3];
    reg_bank4  =reg_bank[4];
    reg_bank5  =reg_bank[5];
    reg_bank6  =reg_bank[6];
    reg_bank7  =reg_bank[7];
    reg_bank8  =reg_bank[8];
    reg_bank9  =reg_bank[9];
    reg_bank10 =reg_bank[10];
    reg_bank11 =reg_bank[11];
    reg_bank12 =reg_bank[12];
    reg_bank13 =reg_bank[13];
    reg_bank14 =reg_bank[14];
    reg_bank15 =reg_bank[15];

end

endmodule
