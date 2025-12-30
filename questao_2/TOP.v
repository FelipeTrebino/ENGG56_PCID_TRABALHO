module TOP(Clock, Reset, Ready, DataIN, Address, ReadEnable, WriteEnable, DataOut);
	
input Clock, Reset;
output Ready;

input [15:0] DataOut; 
output [15:0] DataIN;
output ReadEnable, WriteEnable;
output [4:0] Address; // Memória de 32 bits de profundidade 2^5 = 32

wire [15:0] Acumulador_DataOut;

wire Load, Clear, Transfer;

FSM fsm(.Clock(Clock), .Reset(Reset), .Ready(Ready), .Load(Load), .Clear(Clear), .Transfer(Transfer), .ReadEnable(ReadEnable), .WriteEnable(WriteEnable), .Address(Address));
Acumulador acumulador(.Clock(Clock), .DataIN(DataOut), .Load(Load), .Clear(Clear), .Transfer(Transfer), .DataOut(Acumulador_DataOut));

assign DataIN = Acumulador_DataOut; // Saída do TOP

endmodule