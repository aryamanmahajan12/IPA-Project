module testbench;

 reg clk;
 reg [63:0] PC;

 wire [3:0] icode;
 wire [3:0] ifun;
 wire [3:0] rA;
 wire [3:0] rB; 
 wire [63:0] valC;
 wire [63:0] valP;
 wire invalid_inst;
 wire imem_error;
 wire halt;

fetch my_fetch(.clk(clk),.PC(PC),.icode(icode),.ifun(ifun),
.rA(rA),.rB(rB),.valC(valC),.valP(valP),
.invalid_inst(invalid_inst),
.imem_error(imem_error),.halt(halt));



initial  
begin

PC=64'd0;
clk=0;

#10 clk=~clk;PC=64'd0;    
#10 clk= ~clk;
#10 clk=~clk;PC=valP;
#10 clk=~clk;
#10 clk=~clk;PC=valP;
#10 clk=~clk;




end

  initial 
	begin	
    $monitor("clk=%d PC=%d icode=%b ifun=%b rA=%b rB=%b,valC=%d,valP=%d, invalid inst =%b\n",clk,PC,icode,ifun,rA,rB,valC,valP,invalid_inst);
  end

endmodule
