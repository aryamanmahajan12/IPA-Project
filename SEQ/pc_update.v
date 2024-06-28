module pc_update(clk,PC,Cnd,icode,valC,valM,valP,PC_new);

  input clk;
  input Cnd;
  input [3:0]  icode;
  input [63:0] valC;
  input [63:0] valP;
  input [63:0] valM;
  input [63:0] PC;
  output reg [63:0] PC_new;

  always@(*)
  begin
    PC_new = valP;
    if(icode==4'b0111) //jxx
    begin
      if(Cnd==1'b1)
      begin
        PC_new = valC;
      end
    end
    else if(icode==4'b1000) //call
    begin
      PC_new = valC;
    end
    else if(icode==4'b1001) //ret
    begin
      PC_new = valM;
    end
    end

endmodule