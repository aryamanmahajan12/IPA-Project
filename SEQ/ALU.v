`include "Operations.v"

module ALU64(A,B,O,OF,Ctrl);

input [63:0] A;
input [63:0] B;
input [1:0] Ctrl;

reg [1:0] C;
output reg [63:0] O;
output reg OF;

wire [63:0] w1,w2,w3,w4;
wire wof1,wof2;

ADDER64 A0(A,B,w1,wof1);
SUBTRACTOR64 A1(A,B,w2,wof2);
AND64 A2(A,B,w3);
XOR64 A3(A,B,w4);

always@(*) begin
    case(Ctrl)    
        2'b00:begin
            O = w1;
            OF = wof1;
        end 
        
        2'b01:begin
            O = w2;
            OF = wof2;
        end

        2'b10:begin
            O = w3;
            OF = 1'b0;
        end

        2'b11:begin
            O = w4;
            OF = 1'b0;
        end
        
        default: begin
           
        end
    endcase
end

endmodule