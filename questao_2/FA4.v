module FA4(CIn, COut, A, B, S);// 4 bits Full Adder 

input [3:0] A,B; // A + B 
input  CIn; // Carry_In
output COut; // Carry_Out
output [3:0] S; // Saída\\

wire C1,C2,C3;

FA fa1(.A(A[0]),.B(B[0]),.Cin(CIn),.COut(C1),.S(S[0]));
FA fa2(.A(A[1]),.B(B[1]),.Cin(C1),.COut(C2),.S(S[1]));
FA fa3(.A(A[2]),.B(B[2]),.Cin(C2),.COut(C3),.S(S[2]));
FA fa4(.A(A[3]),.B(B[3]),.Cin(C3),.COut(COut),.S(S[3]));

endmodule; 