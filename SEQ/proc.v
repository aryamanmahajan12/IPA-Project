`include "fetch.v"
`include "decode.v"
`include "memory.v"
`include "decode_writeback.v"
`include "execute.v"
`include "pc_update.v"



module proc;
  wire [3:0] icode;
  wire [3:0] ifun;
  wire [3:0] rA;
  wire [3:0] rB; 
  wire signed [63:0] valC;
  wire signed [63:0] valP;
  wire invalid_inst,imem_error,dmem_error,halt;
  wire signed [63:0] valA;
  wire signed [63:0] valB;
  wire signed[63:0] valE;
  wire signed [63:0] valM;
  wire cnd;
  wire signed [63:0] new_pc;
  wire ZF,SF,OF;


wire signed [63:0] reg_bank0;
wire signed[63:0] reg_bank1;
wire signed [63:0] reg_bank2;
wire signed [63:0] reg_bank3;
wire signed [63:0] reg_bank4;
wire signed [63:0] reg_bank5;
wire signed [63:0] reg_bank6;
wire signed [63:0] reg_bank7;
wire signed [63:0] reg_bank8;
wire signed [63:0] reg_bank9;
wire signed [63:0] reg_bank10;
wire signed [63:0] reg_bank11;
wire signed [63:0] reg_bank12;
wire signed [63:0] reg_bank13;
wire signed [63:0] reg_bank14;

wire signed [63:0] memdata;

reg clk;
reg [63:0] PC;
reg [1:0] Instr_Status;

// reg [63:0] reg_bank    [0:14];
// reg [63:0] data_memory [0:1023];
// reg [63:0] stack_memory[0:1023];
// reg [63:0] inst_memory [0:1023];


fetch fetch(clk,PC,icode,ifun,rA,rB,valC,valP,invalid_inst,imem_error,halt);

decode_wb decode_writeback(clk,icode,rA,rB,cnd,valC,valA,valB,valE,valM,reg_bank0,reg_bank1,reg_bank2,reg_bank3,reg_bank4,
reg_bank5,reg_bank6,reg_bank7,reg_bank8,reg_bank9,reg_bank10,reg_bank11,reg_bank12,reg_bank13,reg_bank14);

execute execute(clk,icode,ifun,valA,valB,valC,valE,cnd,ZF,SF,OF);

memory memory(clk,icode,rA,rB,valA,valB,valC,valE,valP,valM,memdata,dmem_error);

pc_update pc_update(clk,PC,cnd,icode,valC,valM,valP,new_pc);


initial  

begin
  $dumpfile("proc.vcd");
  $dumpvars(0, proc);
  PC=64'd0;
  clk=0;
  Instr_Status=2'b00;
end


always@(*)
begin
  if(halt==1'b1)
  begin
    Instr_Status=2'b01;
    #1 $finish;
  end
  else if(imem_error==1'b1 || dmem_error==1'b1)
  begin
    Instr_Status=2'b10;
    #1 $finish;
  end
  else if(invalid_inst==1'b1)
  begin
    Instr_Status=2'b11;
    #1 $finish;
  end
end

always #10 clk = ~clk;

always@(*)
begin
  PC = new_pc;
end


  initial 
	begin	
    $monitor(" clk  = %d\n PC =%d \n \n icode= %b         ifun= %b \n rA   = %b         rB= %b \n \n valC=%d\tvalP=%d\n valA=%d\tvalB=%d \n valE=%d\tvalM=%d \n \n Instruction Status = %d\n AOK = 0, HLT = 1, ADR = 2, INS = 3 \n\n Condition Flags :\n ZF =%d\n SF =%d\n OF =%d\n \n Encoding Registers \n rax=%d \n rcx=%d\n rdx=%d\n rbx=%d\n rsp=%d\n rbp=%d \n rsi=%d\n rdi=%d\n r8 =%d\n r9 =%d\n r10=%d\n r11=%d\n r12=%d\n r13=%d\n r14=%d\n \nmemdata=%d\n(Data in mem[ValE])\n \n ------------------------------------------------------\n",clk,PC,icode,ifun,rA,rB,valC,valP,valA,valB,valE, valM,Instr_Status,ZF,SF,OF,reg_bank0,reg_bank1,reg_bank2,reg_bank3,reg_bank4,reg_bank5,reg_bank6,reg_bank7,reg_bank8,reg_bank9,reg_bank10,reg_bank11,reg_bank12,reg_bank13,reg_bank14,memdata);
  end

endmodule