`timescale 1ns / 1ps

module tb_RemoteController;

    // Entradas do DUT (Device Under Test)
    reg Clock;
    reg Reset;
    reg Serial;

    // Saídas do DUT
    wire [7:0] Tecla;
    wire Ready;

    // Instanciação do Módulo
    RemoteController uut (
        .Clock(Clock), 
        .Reset(Reset), 
        .Serial(Serial), 
        .Tecla(Tecla), 
        .Ready(Ready)
    );

    // Geração de Clock (Periodo = 10ns -> 100MHz)
    always #5 Clock = ~Clock;

    // -------------------------------------------------------------------------
    // TASK: Enviar Tecla
    // Simula o envio de um pacote IR completo:
    // 1. Baixa a linha (Start Bit)
    // 2. Envia 16 bits de Custom Code + 8 bits Tecla + 8 bits Inverso
    // -------------------------------------------------------------------------
    task enviar_tecla;
        input [15:0] custom_code;
        input [7:0]  key_code;
        
        reg [31:0] pacote_completo;
        integer i;
        
        begin
            // Monta o pacote: [Custom(16)] + [Key(8)] + [~Key(8)]
            // O ~key_code é necessário para passar na verificação do estado CHECK
            pacote_completo = {custom_code, key_code, ~key_code};

            // 1. Start Bit: A linha fica LOW por 1 ciclo para tirar o DUT do IDLE
            @(negedge Clock);
            Serial = 1'b0; 
            
            // 2. Loop de envio dos 32 bits
            // O DUT desloca {shifter, Serial}, então enviamos do MSB (bit 31) ao LSB
            for (i = 31; i >= 0; i = i - 1) begin
                @(negedge Clock); // Muda o dado na borda de descida para estabilidade
                Serial = pacote_completo[i];
            end

            // 3. Fim da transmissão: Volta para Idle (High)
            @(negedge Clock);
            Serial = 1'b1;

            // Aguarda alguns clocks para dar tempo do DUT processar (CHECK -> OUTPUT -> IDLE)
            repeat(10) @(posedge Clock);
        end
    endtask

    // -------------------------------------------------------------------------
    // Bloco Principal de Teste
    // -------------------------------------------------------------------------
    initial begin
        // Inicialização
        Clock = 0;
        Reset = 1;
        Serial = 1; // Protocolo NEC/IR geralmente é High quando ocioso

        // Reset do sistema
        #20;
        Reset = 0;
        #20;

        // --- TESTE 1: Tecla A (Código 0x1A) ---
        $display("Enviando Tecla A (0x1A)...");
        enviar_tecla(16'h00FF, 8'h1A);
        
        // Verifica se funcionou
        if (Ready && Tecla == 8'h1A) 
            $display("-> SUCESSO: Tecla 1A recebida!");
        else 
            $display("-> FALHA na Tecla 1A.");

        // Espera um tempo entre cliques (simulando o usuário soltando o botão)
        #100;

        // --- TESTE 2: Tecla B (Código 0xB2) ---
        $display("Enviando Tecla B (0xB2)...");
        enviar_tecla(16'h00FF, 8'hB2);

        if (Ready && Tecla == 8'hB2) 
            $display("-> SUCESSO: Tecla B2 recebida!");
        
        #100;

        // --- TESTE 3: Tecla com Erro (Ruído) ---
        // Aqui vamos forçar um erro enviando o Checksum errado manualmente
        // O DUT deve ignorar e NÃO ativar o Ready
        $display("Enviando Ruido (Checksum Invalido)...");
        
        @(negedge Clock); Serial = 0; // Start
        // Envia lixo: Custom(FFFF) + Key(55) + Checksum ERRADO (55 em vez de AA)
        // Isso deve falhar no estado CHECK
        repeat(32) begin
            @(negedge Clock); Serial = 1'b1; // Enviando tudo 1
        end
        @(negedge Clock); Serial = 1'b1; // Volta a High

        #50;
        
        if (Ready == 0) 
            $display("-> SUCESSO: Ruido ignorado corretamente.");
        else
            $display("-> FALHA: O modulo aceitou dados invalidos!");

        #100;
        $stop;
    end

endmodule