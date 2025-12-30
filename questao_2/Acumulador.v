module Acumulador(Clock, DataIN, Load, Clear, Transfer, DataOut);

input [15:0] DataIN;
input Load, Clear, Transfer, Clock;

output [15:0] DataOut;

wire [15:0] B; // Saída do Registrador B
wire [15:0] A; // Saída do Registrador A
wire [15:0] S; // Saída de Soma do somador
wire COut; // Saída de Carry do somador

Registrador_B reg_b(.Clock(Clock), .Enable(Load), .D(DataIN), .B(B)); // Registrador B (Carrega dados da memória)

FA16 fa16(.CIn(1'b0), .COut(COut), .A(A), .B(B), .S(S)); // Somador de 4 bits

Registrador_A reg_a(.Clock(Clock), .Enable(Transfer) , .Clear(Clear), .D(S), .A(A)); // Registrador A (Acumulador)

assign DataOut = A;

endmodule