module fetch_reg(clk,f_predPC,F_stall,F_bubble,F_predPC);

input wire clk;
input wire F_stall;
input wire F_bubble;
input wire [63:0] f_predPC;

reg flag;
initial flag = 0;

output reg [63:0] F_predPC;

always @(posedge clk)
begin

if(!(F_stall) && !(F_bubble))
begin

    F_predPC = f_predPC;
end



// Assuming bubble is never involved in Fetch stage
// if(F_bubble)
// begin
//     F_predPC <= 
// end

end
endmodule