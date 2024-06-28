module decode(clk,icode,rA,rB,cnd,valA,valB);


input wire clk;
input wire [3:0] icode;
input wire [3:0] rA;
input wire [3:0] rB;
input wire cnd;

output reg [63:0] valA;
output reg [63:0] valB;


reg [63:0] reg_bank[0:14];


initial
begin
    reg_bank[0] =1;
    reg_bank[1] =2;
    reg_bank[2] =3;
    reg_bank[3] =4;
    reg_bank[4] =5;
    reg_bank[5] =6;
    reg_bank[6] =7;
    reg_bank[7] =8;
    reg_bank[8] =9;
    reg_bank[9] =10;
    reg_bank[10]= 11;
    reg_bank[11]= 12;
    reg_bank[12]= 13;
    reg_bank[13]= 14;
    reg_bank[14]= 15;

end






always @(posedge clk)
begin 



if(icode == 4'b0010)//cmov
begin
    valA=reg_bank[rA];
    valB=reg_bank[rB];
end

else if(icode == 4'b0011)//irmov
begin
    valB=reg_bank[rB];
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
    valA=reg_bank[rA];
    valB=reg_bank[rB];   
end
else
begin
    valA=0;
    valB=0;
end


end


endmodule