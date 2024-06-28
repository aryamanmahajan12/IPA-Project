module testbench;

reg   clk;
reg [3:0] icode;
reg [3:0] rA;
reg [3:0] rB;
reg [63:0] valA;
reg [63:0] valB;
reg [63:0] valC;
reg [63:0] valE;
reg [63:0] valP;

wire [63:0] valM;





memory mymem(clk,icode,rA,rB,valA,valB,valC,valE,valP,valM);



initial 
begin

    clk=1;
    icode =0100;
    valB=3;
    valC=5;
    valA=2;

    #10clk=~clk;
    icode =0100;
    valB=3;
    valC=5;
    valA=2;
    
    #10clk=~clk;
    icode =0101;
    valB=3;
    valC=5;
    valA=2;
    
    #10clk=~clk;
    icode =0101;
    valB=3;
    valC=5;
    valA=2;

end


initial
begin
    $monitor("clk=%d icode=%b rA=%b rB=%b,valA=%d,valB=%d valM=%d\n",clk,icode,rA,rB,valA,valB,valM);
end












endmodule