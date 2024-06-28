module testbench;


reg clk;
reg [3:0] icode;
reg [3:0] rA;
reg [3:0] rB;
reg cnd;

wire [63:0] valA;
wire [63:0] valB;




// reg [63:0] reg_bank[0:14];



decode my_decode(.clk(clk),.icode(icode),.rA(rA),.rB(rB),
.cnd(cnd),.valA(valA),.valB(valB));


initial 
begin



clk=0;

    icode = 4'b0010;
   
    rA    = 4'b0001;
   
    rB    = 4'b0010;
   
    cnd   = 0;

    #10 clk=~clk;    
    icode = 4'b0100;

    rA    = 4'b0010;
   
    rB    = 4'b0011;
   
    cnd   = 0;    

    #10 clk=~clk;    
    icode = 4'b0100;

    rA    = 4'b0010;
   
    rB    = 4'b0011;
   
    cnd   = 0;    



    #10 clk=~clk;    
    icode = 4'b0011;

    rA    = 4'b0011;
   
    rB    = 4'b0001;
   
    cnd   = 0;

    #10 clk=~clk;    
    icode = 4'b0011;

    rA    = 4'b0010;
   
    rB    = 4'b0001;
   
    cnd   = 0;



end


initial
begin
    $monitor("clk=%d icode=%b rA=%b rB=%b,valA=%d,valB=%d \n",clk,icode,rA,rB,valA,valB);
end

endmodule