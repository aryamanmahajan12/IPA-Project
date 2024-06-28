module fetchdecodetb;

  reg clk;

  reg [3:0] icode;
  reg [3:0] ifun;

  reg [63:0] valC;
  reg [63:0] valA;
  reg [63:0] valB;
  wire [63:0] valE;
  wire Cnd;


execute execute_1(clk,icode,ifun,valA,valB,valC,valE,Cnd);

  initial begin

    clk=0;
    
    #10 clk=~clk;
    #10 clk=~clk;
    valA = 64'd120;
    valB = 64'd12;
    valC = 64'd35;
    icode = 2; ifun = 0;
    #10 clk=~clk;


  end 
  
  initial 
		$monitor("clk=%d icode=%b ifun=%b valA=%d valB=%d valE=%d Cnd=%d\n",clk,icode,ifun,valA,valB,valE,Cnd);
endmodule