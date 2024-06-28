module testbench;


reg clk;
reg [3:0] icode;
reg [3:0] rA;
reg [3:0] rB;
reg cnd;
reg [63:0] valC;

wire [63:0] valA;
wire [63:0] valB;




// reg [63:0] reg_bank[0:14];



decode_wb my_decode_wb(.clk(clk),.icode(icode),.rA(rA),.rB(rB),
.cnd(cnd),.valC(valC),.valA(valA),.valB(valB));


initial 
begin



clk=0;




    #10 clk=~clk;    
    icode = 4'b0010;//cmov
   
    rA    = 4'b0001;
   
    rB    = 4'b0010;
   
    cnd   = 1;
    valC=0;

    #10 clk=~clk;    
    icode = 4'b0010;//cmov
   
    rA    = 4'b0001;
   
    rB    = 4'b0010;
   
    cnd   = 1;
    valC=0;


//1 cycle complete


    #10 clk=~clk;    
    icode = 4'b1011;//cmov
   
    rA    = 4'b0010;
   
    rB    = 4'b0001;
   
    cnd   = 1;
    valC=0;

    #10 clk=~clk;    
    icode = 4'b1011;//cmov
   
    rA    = 4'b0010;
   
    rB    = 4'b0001;
   
    cnd   = 1;
    valC=0;

    #10 clk=~clk;    
    icode = 4'b0010;//cmov
   
    rA    = 4'b0100;
   
    rB    = 4'b0100;
   
    cnd   = 1;
    valC=0;

    #10 clk=~clk;    
    icode = 4'b0010;//cmov
   
    rA    = 4'b0100;
   
    rB    = 4'b0100;
   
    cnd   = 1;
    valC=0;

//2 cycle complete

    // #10 clk=~clk;    
    // icode = 4'b0010;//cmov
   
    // rA    = 4'b0001;
   
    // rB    = 4'b0010;
   
    // cnd   = 1;
    // valC=0;

    // #10 clk=~clk;    
    // icode = 4'b0010;//cmov
   
    // rA    = 4'b0001;
   
    // rB    = 4'b0010;
   
    // cnd   = 1;
    // valC=0;

    // #10 clk=~clk;    
    // icode = 4'b0010;//cmov
   
    // rA    = 4'b0001;
   
    // rB    = 4'b0010;
   
    // cnd   = 1;
    // valC=0;

end


initial
begin
    $monitor("clk=%d icode=%b rA=%b rB=%b,valA=%d,valB=%d \n",clk,icode,rA,rB,valA,valB);
end

endmodule