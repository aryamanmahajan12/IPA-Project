module ADDER(A,B,M,C0,S,C);

input A,B,C0,M;
output S,C;
wire n0,a0,b0,d0;
xor(n0,M,B);
xor A0(a0,A,n0);
xor S0(S,a0,C0);
and B0(b0,a0,C0);
and D0(d0,A,n0);
or C1(C,b0,d0);

endmodule

module ADDER64(A,B,S,OF);

input signed [63:0] A;
input signed [63:0] B;
output signed [63:0] S;
wire [64:0] C;
output OF;

assign C[0] = 1'b0;

genvar i;

  generate
    for (i = 0; i < 64; i = i + 1) 
    begin 
      ADDER Ad(A[i],B[i],C[0],C[i],S[i],C[i+1]);
    end
  endgenerate

xor X1(OF,C[64],C[63]);

endmodule

module SUBTRACTOR64(A,B,S,OF);

input signed [63:0] A;
input signed [63:0] B;
output signed [63:0] S;
wire [64:0] C;
output OF;

assign C[0] = 1'b1;

genvar i;

  generate
    for (i = 0; i < 64; i = i + 1) 
    begin : Adder
      ADDER Ad(A[i],B[i],C[0],C[i],S[i],C[i+1]);
    end
  endgenerate

xor X1(OF,C[64],C[63]);

endmodule

module AND64(A,B,S);

input [63:0] A;
input [63:0] B;
output [63:0] S;

genvar i;

  generate
    for (i = 0; i < 64; i = i + 1) 
    begin : AND_Gate
      and A1(S[i],A[i],B[i]);
    end
  endgenerate

endmodule

module XOR64(A,B,O);

input [63:0] A;
input [63:0] B;
output [63:0] O;

genvar i;

  generate
    for (i = 0; i < 64; i = i + 1) 
    begin : XOR_Gate
      xor A1(O[i],A[i],B[i]);
    end
  endgenerate

endmodule