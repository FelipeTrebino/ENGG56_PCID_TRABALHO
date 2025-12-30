`timescale 1ns / 1ps

module tb_RemoteController;

    // --- Entradas e Saídas do DUT ---
    reg Clock;
    reg Reset;
    reg Serial;
    wire [7:0] Tecla;
    wire Ready;

    // --- Configuração de Clocks (304 kHz) ---
    // Periodo = ~3289 ns
    parameter CLK_PERIOD = 3289; 
    
    // Instanciação do DUT
    RemoteController uut (
        .Clock(Clock), 
        .Reset(Reset), 
        .Serial(Serial), 
        .Tecla(Tecla), 
        .Ready(Ready)
    );

    // Geração de Clock
    always #(CLK_PERIOD/2) Clock = ~Clock;

    // --- Definição dos Vetores de Teste ---
    // Vamos testar 8 teclas diferentes
    reg [7:0] lista_de_teclas [0:7]; 
    integer k; // Variável para o loop

    // --- TASK: Enviar Tecla ---
    task enviar_tecla;
        input [15:0] custom_code; 
        input [7:0]  key_code;    
        
        reg [31:0] pacote_completo;
        integer i;
        
        begin
            // Prepara o pacote (Custom + Key + ~Key)
            pacote_completo = {custom_code, key_code, ~key_code};

            // 1. Lead Code (Start Bit)
            @(negedge Clock);
            Serial = 1'b0; 
            
            // 2. Envia os 32 bits
            for (i = 31; i >= 0; i = i - 1) begin
                @(negedge Clock); 
                Serial = pacote_completo[i];
            end

            // 3. Volta ao repouso
            @(negedge Clock);
            Serial = 1'b1;

            // Aguarda o processamento da FSM (alguns clocks)
            repeat(10) @(posedge Clock);
        end
    endtask

    // --- Bloco Principal de Teste ---
    initial begin
        // 1. Configuração Inicial
        Clock = 0;
        Reset = 1;
        Serial = 1;
        
        // Define as teclas que queremos testar (Hexadecimal)
        lista_de_teclas[0] = 8'h00; // Zero
        lista_de_teclas[1] = 8'h01; // Um
        lista_de_teclas[2] = 8'h1A; // Letra A
        lista_de_teclas[3] = 8'hB2; // Letra B
        lista_de_teclas[4] = 8'hFF; // Maximo valor
        lista_de_teclas[5] = 8'h55; // Padrão 01010101
        lista_de_teclas[6] = 8'hAA; // Padrão 10101010
        lista_de_teclas[7] = 8'hC3; // Valor aleatório

        // Solta o Reset
        #(CLK_PERIOD * 10);
        Reset = 0;
        #(CLK_PERIOD * 10);

        $display("=== INICIANDO TESTE DE MULTIPLAS TECLAS ===");

        // 2. Loop Automático
        for (k = 0; k < 8; k = k + 1) begin
            
            // A. Envia a tecla atual da lista
            enviar_tecla(16'hFFFF, lista_de_teclas[k]);

            // B. Verificação Automática (Self-Checking)
            // O sinal Ready deve estar ALTO e a Tecla deve bater com a lista
            if (Ready == 1'b1 && Tecla == lista_de_teclas[k]) begin
                $display("[PASS] Teste %0d: Enviado %h -> Recebido %h (OK)", k, lista_de_teclas[k], Tecla);
            end else begin
                $display("[FAIL] Teste %0d: Enviado %h -> Recebido %h (Ready=%b)", k, lista_de_teclas[k], Tecla, Ready);
            end

            // C. Aguarda um tempo entre as teclas (simula usuário soltando o botão)
            #(CLK_PERIOD * 20); 
        end

        // 3. Teste Extra: Tecla Inválida (Para garantir que ele não aceita lixo)
        $display("=== TESTE DE ROBUSTEZ (ERRO) ===");
        
        @(negedge Clock); Serial = 0; // Start
        // Envia lixo (tudo 1)
        repeat(32) @(negedge Clock) Serial = 1; 
        @(negedge Clock) Serial = 1;
        
        #(CLK_PERIOD * 10);
        
        if (Ready == 0) 
            $display("[PASS] Ruido ignorado corretamente.");
        else 
            $display("[FAIL] O modulo aceitou ruido!");

        $display("=== FIM DOS TESTES ===");
        $stop;
    end

endmodule