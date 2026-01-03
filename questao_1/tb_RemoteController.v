`timescale 1ns / 1ps

module tb_RemoteController;

    // =========================================================================
    // 1. SINAIS E INSTÂNCIA DO MÓDULO (DUT)
    // =========================================================================
    reg Clock;
    reg Reset;
    reg Serial;
    wire [7:0] Tecla;
    wire Ready;

    // Instancia o seu módulo principal
    RemoteController uut (
        .Clock(Clock), 
        .Reset(Reset), 
        .Serial(Serial), 
        .Tecla(Tecla), 
        .Ready(Ready)
    );

    // =========================================================================
    // 2. GERAÇÃO DE CLOCK (304 kHz)
    // =========================================================================
    // Período = 1 / 304kHz ≈ 3289 ns -> Metade ≈ 1645 ns
    initial begin
        Clock = 0;
        forever #1645 Clock = ~Clock; 
    end

    // =========================================================================
    // 3. TAREFA PARA ENVIAR PACOTES (Simulando Sensor IR 38kHz)
    // =========================================================================
    task enviar_pacote_38k;
        input [15:0] endereco; // Custom Code (16 bits)
        input [7:0]  comando;  // Key Code (8 bits)
        input [7:0]  inverso;  // Inv Key Code (8 bits - Para validação)
        
        reg [31:0] pacote;
        integer i;
        
        begin
            // Monta o frame completo de 32 bits
            pacote = {endereco, comando, inverso};
            
            // Garante linha em repouso (High) antes de começar
            Serial = 1;
            #30000; 

            $display(">> [TX] Enviando: Cmd=%h | Inv=%h", comando, inverso);

            // Loop de envio bit a bit (MSB first) a 38kHz
            for (i = 31; i >= 0; i = i - 1) begin
                Serial = pacote[i]; 
                #26315;             // Duração de 1 bit (1/38kHz ≈ 26315ns)
            end
            
            // Retorna ao repouso
            Serial = 1;
            #50000; // Tempo morto entre pacotes
        end
    endtask

    // =========================================================================
    // 4. SEQUÊNCIA DE TESTES
    // =========================================================================
    initial begin
        $display("--- INICIANDO SIMULACAO COMPLETA (COM TESTE DE ERRO) ---");
        Reset = 1;
        Serial = 1;
        
        // Reset inicial do sistema
        #5000;
        Reset = 0;
        #5000;

        // ------------------------------------------------------------
        // CASO 1: Tecla POWER (0x12) - VÁLIDO
        // Inverso: ~0x12 = 0xED
        // ------------------------------------------------------------
        enviar_pacote_38k(16'h0000, 8'h12, 8'hED);

        if (Tecla == 8'h12)
             $display(">> [SUCESSO] Tecla POWER (12) detectada.");
        else
             $display(">> [FALHA] Esperado 12, recebido %h", Tecla);

        // ------------------------------------------------------------
        // CASO 2: TESTE DE ERRO (Checksum Inválido)
        // Enviamos Tecla '3' (0x03) mas com inverso 0x00 (Errado! Deveria ser FC)
        // O sistema deve IGNORAR e manter o valor anterior (12)
        // ------------------------------------------------------------
        $display("--- Teste de Robustez: Enviando pacote corrompido... ---");
        enviar_pacote_38k(16'h0000, 8'h03, 8'h00); 

        if (Tecla == 8'h12) 
             $display(">> [SUCESSO - ROBUSTEZ] Erro rejeitado. Saida manteve Power (12).");
        else
             $display(">> [FALHA] O sistema aceitou um pacote ruim! Tecla mudou para %h", Tecla);

        // ------------------------------------------------------------
        // CASO 3: Tecla SETA PARA CIMA (0x1A) - VÁLIDO
        // Binário: 0001 1010 -> Inverso: 1110 0101 (0xE5)
        // ------------------------------------------------------------
        enviar_pacote_38k(16'h0000, 8'h1A, 8'hE5);

        if (Tecla == 8'h1A)
             $display(">> [SUCESSO] Seta p/ CIMA (1A) detectada.");
        else
             $display(">> [FALHA] Esperado 1A, recebido %h", Tecla);

        // ------------------------------------------------------------
        // CASO 4: Tecla '1' (0x01) - VÁLIDO
        // Inverso: ~0x01 = 0xFE
        // ------------------------------------------------------------
        enviar_pacote_38k(16'h0000, 8'h01, 8'hFE);

        if (Tecla == 8'h01) 
             $display(">> [SUCESSO] Tecla '1' (01) detectada.");
        else
             $display(">> [FALHA] Esperado 01, recebido %h", Tecla);

        // ------------------------------------------------------------
        // FINALIZAÇÃO
        // ------------------------------------------------------------
        #100000;
        $display("--- Fim da Simulacao ---");
        $stop;
    end

endmodule