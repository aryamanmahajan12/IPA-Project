module memory(clk,icode,rA,rB,valA,valB,valC,valE,valP,valM,memdata,dmem_err);

input wire clk;
input wire [3:0] icode;
input wire [3:0] rA;
input wire [3:0] rB;
input wire [63:0] valA;
input wire [63:0] valB;
input wire [63:0] valC; 
input wire [63:0] valE;
input wire [63:0] valP;

output reg [63:0]valM;
output reg [63:0]memdata;
output reg dmem_err;

reg [63:0] reg_bank [0:14];
reg [63:0] mem [0:1023];

// always@(*)
// dmem_error=0;
//     if(PC > 1023)
//     begin
//       imem_error=1;
//     end

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
    dmem_err = 1'b0;
end



always @(negedge clk)
begin

    if(icode==4'b0100)//rmmov
    begin
        mem[valE] = valA;
        if(valE>1023)
        begin
            dmem_err = 1'b1;
        end
    end

    else if(icode == 4'b1010)//push
    begin
        mem[valE]=valA;
        if(valE>1023)
        begin
            dmem_err = 1'b1;
        end
    end

    else if(icode == 4'b1000)//call
    begin
        mem[valE]=valP;
        if(valE>1023)
        begin
            dmem_err = 1'b1;
        end
    end

    else if(icode==4'b1001)//ret
    begin
        valM=mem[valA];
        if(valE>1023)
        begin
            dmem_err = 1'b1;
        end
    end

memdata=mem[valE];

end

always@(*)
begin
    if(icode==4'b0101)//mrmov
    begin
        valM=mem[valE];
        if(valE>1023)
        begin
            dmem_err = 1'b1;
        end
    end

    else if(icode == 4'b1011)//pop
    begin
        valM=mem[valA];
        if(valA>1023)
        begin
            dmem_err = 1'b1;
        end
    end
end

endmodule