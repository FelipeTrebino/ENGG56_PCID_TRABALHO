`timescale 1ns/1ps

module tb_TrafficController;
    reg A, B, C, D;
    wire L_O, N_S;
    

    integer i;

    TrafficController uut (
        .A(A), .B(B), .C(C), .D(D),
        .L_O(L_O), .N_S(N_S)
    );

    initial begin

        $display("------------------------------------------------");
        $display("Tempo | Entradas (ABCD) | L_O (Princ) | N_S (Sec) |");
        $display("------------------------------------------------");


        for (i = 0; i < 16; i = i + 1) begin

            {A, B, C, D} = i;
            #10;
            
            $display("%5t |      %b %b %b %b      |      %b      |     %b     |", 
                     $time, A, B, C, D, L_O, N_S);
        end

        $display("------------------------------------------------");
        $display("Teste Completo Finalizado.");
        $stop;
    end
endmodule