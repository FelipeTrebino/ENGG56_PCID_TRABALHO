module Registrador_A(Enable, Clock, Clear, D, A);

input Clock, Clear, Enable;
input [15:0] D;
output reg [15:0] A;

always @(posedge Clock or posedge Clear)
begin
	if(Clear) begin
		A <= 16'b0;
	end else if(Enable) begin
		A <= D;
	end
end
endmodule