module Registrador_A(Clock, Clear, D, A);

input Clock, Clear;
input [15:0] D;
output reg [15:0] A;

always @(posedge Clock or posedge Clear)
begin
	if(Clear)
	begin
		A <= 16'b0;
	end
	else
	begin
		A <= D;
	end
end
endmodule