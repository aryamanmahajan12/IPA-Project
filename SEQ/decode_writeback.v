module decode_wb(clk,icode,rA,rB,cnd,valC,valA,valB,valE,valM,reg_bank0,reg_bank1,reg_bank2,reg_bank3,reg_bank4,
reg_bank5,reg_bank6,reg_bank7,reg_bank8,reg_bank9,reg_bank10,reg_bank11,reg_bank12,reg_bank13,reg_bank14);


input wire clk;
input wire [3:0] icode;
input wire [3:0] rA;
input wire [3:0] rB;
input wire cnd;
input wire [63:0] valC;
input wire [63:0] valE;
input wire [63:0] valM;

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


output reg [63:0] valA;
output reg [63:0] valB;

reg [63:0] reg_bank[0:14];

initial
begin
    reg_bank[0] =0;
    reg_bank[1] =0;
    reg_bank[2] =0;
    reg_bank[3] =0;
    reg_bank[4] =1023;
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
end

always @(*)
begin 

if(icode == 4'b0010)//cmov
begin
    valA=reg_bank[rA];
    valB=reg_bank[rB];
end

else if(icode == 4'b0011)//irmov
begin
    //valB=reg_bank[rB];
end

else if(icode == 4'b0100)//rmmov
begin
    valA=reg_bank[rA];
    valB=reg_bank[rB];  
end

else if(icode == 4'b0101)//mrmov
begin
    valB=reg_bank[rB];   
end

else if(icode == 4'b0110)//op
begin
    valA = reg_bank[rA];
    valB = reg_bank[rB];   
end

// call and ret have nothing in decode stage

else if(icode == 4'b1010)//push
begin 
    valA=reg_bank[rA];
    valB = reg_bank[4];
end

else if(icode == 4'b1000)//call
begin
    valB=reg_bank[4];   
end

else if(icode == 4'b1011 || icode == 4'b1001)//pop & ret
begin 
    valA=reg_bank[4]; 
    valB=reg_bank[4]; 
end






    reg_bank0 =reg_bank[0];
    reg_bank1 =reg_bank[1];
    reg_bank2 =reg_bank[2];
    reg_bank3 =reg_bank[3];
    reg_bank4 =reg_bank[4];
    reg_bank5 =reg_bank[5];
    reg_bank6 =reg_bank[6];
    reg_bank7 =reg_bank[7];
    reg_bank8 =reg_bank[8];
    reg_bank9 =reg_bank[9];
    reg_bank10=reg_bank[10];
    reg_bank11=reg_bank[11];
    reg_bank12=reg_bank[12];
    reg_bank13=reg_bank[13];
    reg_bank14=reg_bank[14];

end



//parameter idx=4'b0100;


always @(negedge clk)
begin

    if(icode == 4'b0010)//cmov
    begin
    if(cnd==1)
    begin
        reg_bank[rB] = reg_bank[rA];
    end 
    end
    
    else if(icode ==4'b0011)//irmov
    begin
    //we have rB basically. And we need valC.
    reg_bank[rB]=valE;
    end
    
    else if(icode ==4'b0100)//rmmov
    begin
    //nothing to be done really
    end
    
    else if(icode ==4'b0101)//mrmov
    begin    
    reg_bank[rA]=valM;
    end
    
    else if(icode ==4'b0110)//op
    begin
    reg_bank[rB]=valE;
    end

    else if(icode ==4'b1010)//push
    begin
        //reg_bank[4] = reg_bank[4]-64'd8;
        reg_bank[4]=valE;
    end

    else if(icode ==4'b1011)//pop
    begin
        //reg_bank[4] = reg_bank[4]+64'd8;
        reg_bank[4]=valE;
        reg_bank[rA] = valM;
    end

    else if(icode ==4'b1000 || icode ==4'b1001)//call & ret
    begin
        reg_bank[4]=valE;
    end

    reg_bank0 =reg_bank[0];
    reg_bank1 =reg_bank[1];
    reg_bank2 =reg_bank[2];
    reg_bank3 =reg_bank[3];
    reg_bank4 =reg_bank[4];
    reg_bank5 =reg_bank[5];
    reg_bank6 =reg_bank[6];
    reg_bank7 =reg_bank[7];
    reg_bank8 =reg_bank[8];
    reg_bank9 =reg_bank[9];
    reg_bank10=reg_bank[10];
    reg_bank11=reg_bank[11];
    reg_bank12=reg_bank[12];
    reg_bank13=reg_bank[13];
    reg_bank14=reg_bank[14];



end

endmodule