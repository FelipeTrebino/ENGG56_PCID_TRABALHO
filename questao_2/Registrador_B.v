module Registrador_B(Enable,Clock,D,B);

input Clock, Enable;
input [15:0] D;
output reg [15:0] B;

always @(posedge Clock)
begin
	if(Enable) begin
		B <= D;
	end
end
endmodule