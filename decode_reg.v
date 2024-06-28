module decode_reg(clk,
f_icode,f_ifun,f_rA,f_rB,f_valC,f_valP,f_stat,
D_stat,D_icode,D_ifun,D_rA,D_rB,D_valC,D_valP,
D_stall,D_bubble);

input clk;

input wire [3:0] f_icode,f_ifun,f_rA,f_rB;
output reg [3:0] D_icode,D_ifun,D_rA,D_rB;

input wire [2:0] f_stat;
output reg [2:0] D_stat;
input wire D_stall,D_bubble;

input wire [63:0] f_valC,f_valP;
output reg [63:0] D_valC,D_valP;

always @(posedge clk)
begin

if(!(D_bubble) && !(D_stall))
begin
D_stat <= f_stat;
D_rA <= f_rA;
D_rB <= f_rB;
D_icode <= f_icode;
D_ifun <= f_ifun;
D_valP <= f_valP;
D_valC <= f_valC;
end


if(D_bubble && !(D_stall)) // as bubble case is already handled in fetch block and reg inputs are adjusted, and bubble here is accompanied by stall in fetch
begin
    //if(jump_ins_cnd)f_predPC=jump_ins_pred;
    D_stat <= 1;
    D_icode <=4'b0001;
    D_ifun <=4'b0000;
end

if((D_stall && !D_bubble) || (D_bubble && D_stall))
begin

end




end


endmodule