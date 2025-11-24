module FSM(Clock, Reset, Ready, Load, Clear, Transfer, ReadEnable, WriteEnable, Address);

input Clock, Reset;
output reg Ready, Load, Clear, Transfer, ReadEnable, WriteEnable;
output reg [4:0] Address; // Memória de 32 bits -> 2^5

endmodule;