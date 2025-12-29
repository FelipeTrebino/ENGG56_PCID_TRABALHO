`timescale 1ns/1ps

module tb_RemoteController;

    reg Clock;
    reg Reset;
    reg Serial;
    wire [7:0] Tecla;
    wire Ready;

    // Instancia o DUT (Device Under Test)
    RemoteController uut (
        .Clock(Clock),
        .Reset(Reset),
        .Serial(Serial),
        .Tecla(Tecla),
        .Ready(Ready)
    );

    // Geração de Clock (Período = 10ns)
    always #5 Clock = ~Clock;

    // Tarefa auxiliar para simular o envio do controle remoto
    task enviar_frame;
        input [15:0] custom;
        input [7:0] key;
        input [7:0] inv_key;
        integer i;
        begin
            // 1. Lead Code (1 bit em nível baixo)
            @(negedge Clock) Serial = 0; 
            
            // 2. Envia Custom Code (16 bits) - MSB primeiro
            for (i=15; i>=0; i=i-1) begin
                @(negedge Clock) Serial = custom[i];
            end
            
            // 3. Envia Key Code (8 bits)
            for (i=7; i>=0; i=i-1) begin
                @(negedge Clock) Serial = key[i];
            end

            // 4. Envia Inv Key Code (8 bits)
            for (i=7; i>=0; i=i-1) begin
                @(negedge Clock) Serial = inv_key[i];
            end

            // 5. End Code (Volta para nível alto/repouso)
            @(negedge Clock) Serial = 1;
        end
    endtask

    initial begin
        // Configuração Inicial
        Clock = 0;
        Reset = 1;
        Serial = 1; // Repouso é 1
        #20 Reset = 0; // Solta o Reset

        $display("Iniciando Teste RemoteController...");

        // --- CASO 1: Transmissão Válida (Tecla A = 0x0F) ---
        // Custom=0AAAA, Key=0x0F, InvKey=0xF0 (Correto: 0F é inverso de F0)
        #50;
        enviar_frame(16'hAAAA, 8'h0F, 8'hF0);
        
        // Espera o processamento (tempo suficiente para ler e gerar saída)
        #500;
        
        // --- CASO 2: Transmissão Inválida (Simulação de Ruído) ---
        // Custom=0AAAA, Key=0x0F, InvKey=0x00 (Errado! Deveria ser F0)
        $display("Testando erro de validacao...");
        enviar_frame(16'hAAAA, 8'h0F, 8'h00);
        
        #200;
        $stop;
    end

endmodule