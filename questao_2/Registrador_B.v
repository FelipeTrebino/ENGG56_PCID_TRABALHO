module Registrador_B(Clock,D,B);

input Clock;
input [15:0] D;
output reg [15:0] B;

always @(posedge Clock)
begin
	B <= D;
end
endmodule