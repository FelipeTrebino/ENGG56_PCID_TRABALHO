module FA(A, B, S, CIn, COut); // 1 bit Full Adder 

input A,B; // A + B
input CIn; // Carry In
output reg S, COut; // Sa�da, Carry Out

always @(*)
begin
	S = A ^ B ^ CIn; // XOR 
	COut = ((A & B) | (A & CIn) | (B & CIn)); // AND
end
endmodule