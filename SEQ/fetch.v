module fetch(clk,PC,icode,ifun,rA,rB,valC,valP,invalid_inst,imem_error,halt);

input wire clk;
input wire [63:0] PC;

output reg [3:0] icode;
output reg [3:0] ifun;
output reg [3:0] rA;
output reg [3:0] rB; 
output reg [63:0] valC;
output reg [63:0] valP;
output reg invalid_inst;
output reg imem_error;
output reg halt;

reg [7:0] instr_mem[0:1023];
reg [0:79] instr;

initial 
begin
       $readmemb("test.txt",instr_mem,0,63);
end

always@(posedge clk)
begin

    imem_error=0;
    if(PC > 1023)
    begin
      imem_error=1;
    end


    else 

    begin
      
      //concatenating bits to fetch largest possible instr
      instr={instr_mem[PC],
      instr_mem[PC+1],
      instr_mem[PC+2],
      instr_mem[PC+3],
      instr_mem[PC+4],
      instr_mem[PC+5],
      instr_mem[PC+6],
      instr_mem[PC+7],
      instr_mem[PC+8],
      instr_mem[PC+9]};
      
      icode = instr[0:3];
      ifun  = instr[4:7];
      invalid_inst=0;
      halt=0;


      if(icode == 4'b0000)//halt
      begin
        if(ifun==4'b0000)
        begin
        halt=1;
        valP= PC+64'd1;
        end

        else
        begin
        invalid_inst=1;
        valP= PC+64'd1;
        end
      end

      else if(icode == 4'b0001)//nop
      begin

        if(ifun==4'b0000)
        begin
        valP= PC+64'd1;
        end

        else
        begin
        invalid_inst=1;
        valP= PC+64'd1;
        end
      end

      else if(icode == 4'b0010)//cmov
      begin

        if(ifun >= 4'b0000 | ifun<= 4'b0110)
        begin        
        rA=instr[8:11];
        rB=instr[12:15];
        valP= PC+64'd2;
        end


        else
        begin
          valP=PC + 64'd1;
          invalid_inst=1;
        end
      end

      else if(icode == 4'b0011)//irmov
      begin
        if(ifun==4'b0000)
        begin
        rA=instr[8:11];
        rB=instr[12:15];
        valC = {instr[72:79],instr[64:71],instr[56:63],instr[48:55],instr[40:47],instr[32:39],instr[24:31],instr[16:23]};
        valP= PC+64'd10;
        end

        else
        begin
          valP=PC + 64'd1;
          invalid_inst=1;
        end
      end






      else if(icode == 4'b0100)//rmmov
      begin
        if(ifun==4'b0000)
        begin
        rA=instr[8:11];
        rB=instr[12:15];
        valC = {instr[72:79],instr[64:71],instr[56:63],instr[48:55],instr[40:47],instr[32:39],instr[24:31],instr[16:23]};
        valP= PC+64'd10;
        end

        else
        begin
          valP=PC + 64'd1;
          invalid_inst=1;
        end
      end




      else if(icode == 4'b0101)//mrmov
      begin
        if(ifun==4'b0000)
        begin
        rA=instr[8:11];
        rB=instr[12:15];
        valC = {instr[72:79],instr[64:71],instr[56:63],instr[48:55],instr[40:47],instr[32:39],instr[24:31],instr[16:23]};
        valP= PC+64'd10;
        end

        else
        begin
          valP=PC + 64'd1;
          invalid_inst=1;
        end
      end






      else if(icode == 4'b0110)//op
      begin
        if(ifun>=4'b0000 | ifun <= 4'b0110)
        begin
        rA=instr[8:11];
        rB=instr[12:15];
        valP=PC+64'd2;
        end
        else
        begin
          valP=PC + 64'd1;
          invalid_inst=1;
        end
      end




      else if(icode == 4'b0111)//jump
      begin
        if(ifun>=4'b0000 | ifun <= 4'b0110)
        begin
        valC = {instr[64:71],instr[56:63],instr[48:55],instr[40:47],instr[32:39],instr[24:31],instr[16:23],instr[8:15]};
        valP= PC+64'd9;
        end
        else
        begin
          valP=PC + 64'd1;
          invalid_inst=1;
        end
      end




      else if(icode == 4'b1000)//call
      begin
        if(ifun==4'b0000)
        begin
        valC = {instr[64:71],instr[56:63],instr[48:55],instr[40:47],instr[32:39],instr[24:31],instr[16:23],instr[8:15]};
        valP=PC+64'd9;
        end

        else
        begin
          valP=PC + 64'd1;
          invalid_inst=1;
        end
      end




      else if(icode == 4'b1001)//ret
      begin
        if(ifun==4'b0000)
        begin
        valP=PC+64'd1;
        end
        else
        begin
          valP=PC + 64'd1;
          invalid_inst=1;
        end
      end





      else if(icode == 4'b1010)//push
      begin
        if(ifun==4'b0000)
        begin
        rA=instr[8:11];
        rB=instr[12:15];
        valP=PC+64'd2;
        end
        else
        begin
          valP=PC + 64'd1;
          invalid_inst=1;
        end
      end  



      else if(icode == 4'b1011)//pop
      begin
        
        if(ifun==4'b0000)
        begin
        rA=instr[8:11];
        rB=instr[12:15];
        valP=PC+64'd2;
        end
        
        else
        begin
          valP=PC + 64'd1;
          invalid_inst=1;
        end
      end   




      else
      begin
        valP=PC + 64'd1;
        invalid_inst=1;
      end


    end

  end


endmodule