`timescale 1ns/1ps

module tb_TrafficController;
    // Entradas (reg para podermos atribuir valores)
    reg A, B, C, D;
    // Saídas (wire para ler o resultado)
    wire L_O, N_S;
    
    // Variável auxiliar para o loop
    integer i;

    // Instancia o seu Design (DUT)
    TrafficController uut (
        .A(A), .B(B), .C(C), .D(D),
        .L_O(L_O), .N_S(N_S)
    );

    initial begin
        // Cabeçalho para facilitar a leitura no console
        $display("------------------------------------------------");
        $display("Tempo | Entradas (ABCD) | L_O (Princ) | N_S (Sec) |");
        $display("------------------------------------------------");

        // Loop de 0 a 15 (todas as 16 combinações binárias)
        for (i = 0; i < 16; i = i + 1) begin
            
            // Atribui os bits do inteiro 'i' para as variáveis A, B, C, D
            // Ex: se i=3 (0011), então A=0, B=0, C=1, D=1
            {A, B, C, D} = i;
            
            // Espera 10ns para o sinal estabilizar
            #10;
            
            // Imprime o resultado desta combinação
            $display("%5t |      %b %b %b %b      |      %b      |     %b     |", 
                     $time, A, B, C, D, L_O, N_S);
        end

        $display("------------------------------------------------");
        $display("Teste Completo Finalizado.");
        $stop;
    end
endmodule