`include "fetch.v"
`include "decode.v"
`include "memory.v"
`include "execute.v"
`include "fetch_reg.v"
`include "decode_reg.v"
`include "memory_reg.v"
`include "execute_reg.v"
`include "wb_reg.v"
`include "select_pc.v"

module proc;

reg clk;
//reg [63:0] PC;
reg F_stall,F_bubble,D_stall,D_bubble,E_stall,E_bubble,M_stall,M_bubble,W_stall,W_bubble;

reg [63:0] my_pc;


wire [63:0] f_valP, f_valC, f_predPC;
wire [3:0] f_icode, f_ifun, f_rA, f_rB;
wire [2:0] f_stat;
wire [63:0] F_predPC;

wire [2:0] D_stat;
wire [3:0] D_icode, D_ifun, D_rA, D_rB;
wire [63:0] D_valC, D_valP;
wire [3:0] d_dstE, d_dstM, d_srcA, d_srcB;
wire [63:0] d_valA, d_valB;

wire [2:0] E_stat;
wire [3:0] E_icode, E_ifun, E_srcA, E_srcB, E_dstE, E_dstM;
wire [63:0] E_valA, E_valB, E_valC;
wire [63:0] e_valE,e_valA;
wire [3:0] e_dstE;
wire e_cnd;

wire M_cnd;
wire [2:0] M_stat;
wire [3:0] M_icode, M_dstE, M_dstM;
wire [63:0] M_valA, M_valE;
wire [2:0] m_stat;
wire [63:0] m_valE, m_valM;

wire [2:0] W_stat;
wire [63:0] W_valM, W_valE;
wire [3:0] W_icode, W_dstM, W_dstE;

wire signed [63:0] reg_bank0;
wire signed [63:0] reg_bank1;
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
wire signed [63:0] reg_bank15;

wire [63:0] PC_new;
wire signed [63:0] memdata;

//wire [63:0] reg_wire [0:14];


// reg [63:0] reg_bank    [0:14];
// reg [63:0] data_memory [0:1023];
// reg [63:0] stack_memory[0:1023];
// reg [63:0] inst_memory [0:1023];


fetch_reg Fr(clk,f_predPC,F_stall,F_bubble,F_predPC);

select_pc spc(clk, F_predPC, W_valM, M_valA, M_icode, W_icode, M_cnd, PC_new);

fetch F(clk,
my_pc,M_icode,W_icode,M_cnd,M_valA,W_valM,
D_stall,D_bubble,F_stall,
f_icode,f_ifun,f_rA,f_rB,f_valC,f_valP,f_predPC,f_stat);

decode_reg Dr(clk,
f_icode,f_ifun,f_rA,f_rB,f_valC,f_valP,f_stat,
D_stat,D_icode,D_ifun,D_rA,D_rB,D_valC,D_valP,
D_stall,D_bubble);

decode D(
clk,D_bubble,
D_stat,D_icode,D_ifun,D_rA,D_rB,D_valC,D_valP,
e_dstE,e_valE,M_dstE,M_valE,M_dstM,m_valM,W_dstM,W_valM,W_dstE,W_valE,
W_stat,W_icode,
d_valA,d_valB,d_srcA,d_srcB,d_dstE,d_dstM,
reg_bank0,reg_bank1,reg_bank2,reg_bank3,reg_bank4,
reg_bank5,reg_bank6,reg_bank7,reg_bank8,reg_bank9,reg_bank10,reg_bank11,reg_bank12,reg_bank13,reg_bank14,reg_bank15
);

execute_reg Er(clk,
E_bubble,
D_stat,D_icode,D_ifun,d_valA,d_valB,D_valC,d_srcA,d_srcB,d_dstE,d_dstM,
E_stat,E_icode,E_ifun,E_valA,E_valB,E_valC,E_srcA,E_srcB,E_dstE,E_dstM
);

execute E(
clk,
E_icode,E_ifun,E_stat,E_valC,E_valA,E_valB,E_srcA,E_srcB,E_dstE,E_dstM,
m_stat,W_stat,
e_valE,e_valA,e_cnd,e_dstE
);

mem_reg Mr(
clk,M_bubble,
E_icode,E_stat,e_valE,e_valA,e_cnd,e_dstE,E_dstM,
M_icode,M_stat,M_valE,M_valA,M_cnd,M_dstE,M_dstM
);

memory M(
clk, 
M_stat, M_icode,M_valE,M_valA,M_dstE,M_dstM,M_cnd,
m_stat,m_valE,m_valM,memdata
);

writeback_reg Wbr(clk,W_stall,M_icode,M_valE,M_dstE,M_dstM,m_stat,m_valM,W_stat,W_icode,W_valE,W_valM,W_dstE,W_dstM);

initial  
begin
  $dumpfile("proc.vcd");
  $dumpvars(0, proc);
  my_pc=64'd0;
  clk=0;

end

always@(*)
begin
  // if(!(f_stat==3'b001 || D_stat==3'b001 || E_stat==3'b001 || M_stat==3'b001 || W_stat==3'b001) )
  // #1 $finish;
  if (W_stat !=3'b001)
    $finish;
end



always@(*)
begin
 my_pc = PC_new;
end


always #10 clk = ~clk;

// always@(*)
// begin
//   PC = F_predPC;
// end

initial
begin
F_stall  = 0;
F_bubble = 0;
D_stall  = 0;
D_bubble = 0;
E_stall  = 0;
E_bubble = 0;
M_stall  = 0;
M_bubble = 0;
W_stall  = 0;
W_bubble = 0;

//#250 $finish;
end

always@(*)
begin
    if(((E_icode==4'b0101 | E_icode==4'b1011) && (E_dstM==d_srcA | E_dstM==d_srcB)) | (D_icode==4'b1001 | E_icode==4'b1001 | M_icode==4'b1001))
    F_stall  = 1;
    else
    F_stall  = 0;

    if(((E_icode==4'b0101 | E_icode==4'b1011) && (E_dstM==d_srcA | E_dstM==d_srcB)))
    D_stall  = 1;
    else
    D_stall  = 0;

    if ((E_icode==4'b0111 && !e_cnd) | ((!((E_icode==4'b0101 | E_icode==4'b1011) && (E_dstM==d_srcA | E_dstM==d_srcB))) && (D_icode==4'b1001 | E_icode==4'b1001 | M_icode==4'b1001)))
    D_bubble = 1;
    else
    D_bubble  = 0;

    if((E_icode==4'b0111 && !e_cnd) | ((E_icode==4'b0101 | E_icode==4'b1011) && (E_dstM==d_srcA | E_dstM==d_srcB)))
      E_bubble =1;
    else
      E_bubble =0;  


    if((m_stat!=3'b001) | (W_stat!=3'b001))
    M_bubble=1;
    else
    M_bubble=0;

    if (W_stat!=3'b001)
      W_stall=1;
      else
      W_stall=0;

end


  initial 
	begin	
    $monitor(" clk  = %d\n my_PC =%d \n \n f_icode= %b         f_ifun= %b \n f_rA   = %b         f_rB= %b \n \n f_valC=%d\n f_stat = %d\n f_predPC = %d,   F_predPC = %d\n Encoding Registers \n rax=%d \n rcx=%d\n rdx=%d\n rbx=%d\n rsp=%d\n rbp=%d \n rsi=%d\n rdi=%d\n r8 =%d\n r9 =%d\n r10=%d\n r11=%d\n r12=%d\n r13=%d\n r14=%d\nM_valA=%d\nM_valE =%d\nd_valA =%d   d_valB = %d\n memdata=%d\n ------------------------------------------------------\n",clk,my_pc,f_icode,f_ifun,f_rA,f_rB,f_valC,f_stat,f_predPC,F_predPC,reg_bank0,reg_bank1,reg_bank2,reg_bank3,reg_bank4,reg_bank5,reg_bank6,reg_bank7,reg_bank8,reg_bank9,reg_bank10,reg_bank11,reg_bank12,reg_bank13,reg_bank14,M_valA,M_valE,E_valA,E_valB,memdata);
  end

endmodule