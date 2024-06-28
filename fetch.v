module fetch(clk,
my_pc,M_icode,W_icode,M_cnd,M_valA,W_valM,
D_stall,D_bubble,F_stall,
f_icode,f_ifun,f_rA,f_rB,f_valC,f_valP,f_predPC,f_stat);

/*Doubts :
bubble condition in the end : jump_ins_cnd
stat register
*/

input wire clk;
input wire M_cnd;
input wire [63:0] F_predPC; 
input wire [63:0] W_valM;
input wire [63:0] M_valA;
input wire [3:0] W_icode;
input wire [3:0] M_icode;
input wire D_bubble;
input wire D_stall;
input wire F_stall;
//input wire F_bubble;
input wire count;
input wire [63:0] my_pc;

//doubt
// input wire jump_ins_cnd;
// input wire jump_ins_pred;

//add stat thingy
output reg [3:0] f_icode;
output reg [3:0] f_ifun;
output reg [3:0] f_rA;
output reg [3:0] f_rB; 
output reg [63:0] f_valC;
output reg [63:0] f_valP;
output reg [63:0] f_predPC;
output reg [2:0] f_stat;

reg invalid_inst;
reg imem_error;
reg halt;


reg [7:0] instr_mem[0:4095];
reg [0:79] instr;


initial 
begin
       $readmemb("test.txt",instr_mem,0,1023);
       //my_pc = 0;
       //f_predPC = 0;
end


always@(*)
begin


//select PC that I need to work on currently --------------------------------------

    // if(M_icode==4'b0111 && !M_cnd)
    // begin
    // my_pc=M_valA;
    // end

    // if(W_icode == 4'b1001)
    // begin
    // my_pc=W_valM;
    // end

    // else
    // begin
    //   my_pc = F_predPC;
    // end

//--------------------------------------------------
//add in stat 

    imem_error=0;
    if(my_pc > 4095)
    begin
      imem_error=1;
    end

//actual breaking up of the intruction starts. Drum Rolls !!!!!!

    else 

    begin
      
      //concatenating bits to fetch largest possible instr
      instr={instr_mem[my_pc],
      instr_mem[my_pc+1],
      instr_mem[my_pc+2],
      instr_mem[my_pc+3],
      instr_mem[my_pc+4],
      instr_mem[my_pc+5],
      instr_mem[my_pc+6],
      instr_mem[my_pc+7],
      instr_mem[my_pc+8],
      instr_mem[my_pc+9]};
      
      f_icode = instr[0:3];
      f_ifun  = instr[4:7];
      invalid_inst=0;
      halt=0;


      if(f_icode == 4'b0000)//halt
      begin
        if(f_ifun==4'b0000)
        begin
        halt=1;
        f_valP= my_pc+64'd1;
        f_predPC=f_valP;
        end

        else
        begin
        invalid_inst=1;
        f_valP= my_pc+64'd1;
        end
      end

      else if(f_icode == 4'b0001)//nop
      begin

        if(f_ifun==4'b0000)
        begin
        f_valP= my_pc+64'd1;
         f_predPC=f_valP;

        end

        else
        begin
        invalid_inst=1;
        f_valP= my_pc+64'd1;
        end
      end

      else if(f_icode == 4'b0010)//cmov
      begin

        if(f_ifun >= 4'b0000 | f_ifun<= 4'b0110)
        begin        
        f_rA=instr[8:11];
        f_rB=instr[12:15];
        f_valP= my_pc+64'd2;
        f_predPC=f_valP;

        end


        else
        begin
          f_valP=my_pc + 64'd1;
          invalid_inst=1;
        end
      end

      else if(f_icode == 4'b0011)//irmov
      begin
        if(f_ifun==4'b0000)
        begin
        f_rA=instr[8:11];
        f_rB=instr[12:15];
        f_valC = {instr[72:79],instr[64:71],instr[56:63],instr[48:55],instr[40:47],instr[32:39],instr[24:31],instr[16:23]};
        f_valP= my_pc+64'd10;
        f_predPC=f_valP;

        end

        else
        begin
          f_valP=my_pc + 64'd1;
          invalid_inst=1;
        end
      end

      else if(f_icode == 4'b0100)//rmmov
      begin
        if(f_ifun==4'b0000)
        begin
        f_rA=instr[8:11];
        f_rB=instr[12:15];
        f_valC = {instr[72:79],instr[64:71],instr[56:63],instr[48:55],instr[40:47],instr[32:39],instr[24:31],instr[16:23]};
        f_valP= my_pc+64'd10;
        f_predPC=f_valP;
        end

        else
        begin
          f_valP=my_pc + 64'd1;
          invalid_inst=1;
        end
      end

      else if(f_icode == 4'b0101)//mrmov
      begin
        if(f_ifun==4'b0000)
        begin
        f_rA=instr[8:11];
        f_rB=instr[12:15];
        f_valC = {instr[72:79],instr[64:71],instr[56:63],instr[48:55],instr[40:47],instr[32:39],instr[24:31],instr[16:23]};
        f_valP= my_pc+64'd10;
        f_predPC=f_valP;

        end

        else
        begin
          f_valP=my_pc + 64'd1;
          invalid_inst=1;
        end
      end






      else if(f_icode == 4'b0110)//op
      begin
        if(f_ifun>=4'b0000 | f_ifun <= 4'b0110)
        begin
        f_rA=instr[8:11];
        f_rB=instr[12:15];
        f_valP=my_pc+64'd2;
        f_predPC=f_valP;
        end

        else
        begin
          f_valP=my_pc + 64'd1;
          invalid_inst=1;
        end

      end



// In jump and call, we have set the predicted PC to val C

      else if(f_icode == 4'b0111)//jump
      begin
        if(f_ifun>=4'b0000 | f_ifun <= 4'b0110)
        begin
        f_valC = {instr[64:71],instr[56:63],instr[48:55],instr[40:47],instr[32:39],instr[24:31],instr[16:23],instr[8:15]};
        f_valP= my_pc+64'd9;
        f_predPC=f_valC;

        end
        else
        begin
          f_valP=my_pc + 64'd1;
          invalid_inst=1;
        end
      end



// In jump and call, we have set the predicted PC to val C

      else if(f_icode == 4'b1000)//call
      begin
        if(f_ifun==4'b0000)
        begin
        f_valC = {instr[64:71],instr[56:63],instr[48:55],instr[40:47],instr[32:39],instr[24:31],instr[16:23],instr[8:15]};
        f_valP=my_pc+64'd9;
        f_predPC=f_valC;

        end

        else
        begin
          f_valP=my_pc + 64'd1;
          invalid_inst=1;
        end
      end




      else if(f_icode == 4'b1001)//ret
      begin
        if(f_ifun==4'b0000)
        begin
        f_valP=my_pc+64'd1;
        //typically we dont predict the PC
        f_predPC=f_valP;
        end

        else
        begin
          f_valP=my_pc + 64'd1;
          invalid_inst=1;
        end
      end





      else if(f_icode == 4'b1010)//push
      begin
        if(f_ifun==4'b0000)
        begin
        f_rA=instr[8:11];
        f_rB=instr[12:15];
        f_valP=my_pc+64'd2;
        f_predPC=f_valP;

        end
        else
        begin
          f_valP=my_pc + 64'd1;
          invalid_inst=1;
        end
      end  



      else if(f_icode == 4'b1011)//pop
      begin
        
        if(f_ifun==4'b0000)
        begin
        f_rA=instr[8:11];
        f_rB=instr[12:15];
        f_valP=my_pc+64'd2;
        f_predPC=f_valP;
        end
        
        else
        begin
          f_valP=my_pc + 64'd1;
          invalid_inst=1;
        end
        
      end   

      else
      begin
        f_valP=my_pc + 64'd1;
        invalid_inst=1;
      end
    
    end

    if(F_stall)
    begin
      f_predPC = my_pc;
    end

    if(halt==1)
    f_stat = 3'b010;
    else if(imem_error==1)
    f_stat = 3'b011;
    else if(invalid_inst==1)
    f_stat = 3'b100;
    else
    f_stat = 3'b001;
    // if(D_stall)
    // begin
    // end

end

// reg [63:0] temp_pc;  

// always @(posedge clk)
// begin
// if(!(F_stall) && !(F_bubble))
// begin    
//   F_predPC <= f_predPC;
// end
// end

endmodule