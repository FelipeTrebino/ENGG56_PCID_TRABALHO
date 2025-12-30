`timescale 1ns / 1ps

module tb_RemoteController;

    // =========================================================================
    // 1. SINAIS E DUT
    // =========================================================================
    reg Clock;
    reg Reset;
    reg Serial;
    wire [7:0] Tecla;
    wire Ready;

    // Instancia o seu módulo modificado (com Baud Rate Generator)
    RemoteController uut (
        .Clock(Clock), 
        .Reset(Reset), 
        .Serial(Serial), 
        .Tecla(Tecla), 
        .Ready(Ready)
    );

    // =========================================================================
    // 2. GERAÇÃO DE CLOCK REAL (304 kHz)
    // =========================================================================
    // Frequência: 304 kHz -> Período: ~3289.47 ns
    // Metade do Período (Toggle): ~1645 ns
    initial begin
        Clock = 0;
        forever #1645 Clock = ~Clock; 
    end

    // =========================================================================
    // 3. TAREFA PARA ENVIAR PACOTES A 38 kHz
    // =========================================================================
    // Frequência: 38 kHz -> Período de bit: ~26315 ns
    // Esta tarefa emula o sensor IR enviando dados lentamente
    task enviar_pacote_38k;
        input [15:0] endereco; // 16 bits (geralmente fixos ou ignorados)
        input [7:0]  comando;  // Código da tecla
        input [7:0]  inverso;  // Código inverso para validação
        
        reg [31:0] pacote;
        integer i;
        
        begin
            pacote = {endereco, comando, inverso};
            
            // Garante que a linha comece em repouso (High)
            Serial = 1;
            #30000; // Pequena pausa antes de começar

            // IMPORTANTE: O bit 31 (MSB) deve ser 0 para gerar a borda de descida
            // que acorda a máquina de estados (IDLE -> READ_DATA).
            // Protocolos reais (como NEC) têm um preâmbulo, aqui assumimos
            // que o pacote começa com '0' nos dados.
            
            $display(">> Iniciando transmissao de: %h a 38kHz...", pacote);

            for (i = 31; i >= 0; i = i - 1) begin
                Serial = pacote[i]; // Coloca o bit na linha
                #26315;             // Segura o bit por 26.3us (1 ciclo de 38kHz)
            end
            
            // Volta para repouso
            Serial = 1;
            #50000; // Tempo morto entre pacotes
        end
    endtask

    // =========================================================================
    // 4. CENÁRIOS DE TESTE
    // =========================================================================
    initial begin
        // Inicialização
        $display("--- SIMULACAO INICIADA (Clock: 304kHz | Serial: 38kHz) ---");
        Reset = 1;
        Serial = 1; // Pull-up (IR sem sinal é 1)
        
        // Reset inicial
        #5000;
        Reset = 0;
        #5000; // Espera o sistema estabilizar

        // ------------------------------------------------------------
        // CASO 1: Pacote Válido
        // Endereço: 0000, Tecla: A5 (10100101), Inverso: 5A (01011010)
        // Nota: O Endereço 0000 garante que o primeiro bit seja 0 (Start trigger)
        // ------------------------------------------------------------
        enviar_pacote_38k(16'h0000, 8'hA5, 8'h5A);

        // Verificação
        if (Tecla == 8'hA5 && Ready == 0) // Ready pulsa rápido, talvez já tenha descido
             $display(">> [SUCESSO] Tecla A5 capturada e salva na memoria.");
        else if (Tecla == 8'hA5)
             $display(">> [SUCESSO] Tecla A5 capturada.");
        else
             $display(">> [FALHA] Esperado A5, recebido %h", Tecla);

        // ------------------------------------------------------------
        // CASO 2: Pacote Inválido (Erro de Checksum)
        // Endereço: 0000, Tecla: 33, Inverso: 00 (Errado! Deveria ser CC)
        // ------------------------------------------------------------
        $display("--- Enviando pacote corrompido... ---");
        enviar_pacote_38k(16'h0000, 8'h33, 8'h00);

        // A tecla NÃO deve mudar (deve continuar sendo A5)
        if (Tecla == 8'hA5) 
             $display(">> [SUCESSO] Pacote invalido ignorado. Tecla manteve valor anterior.");
        else
             $display(">> [FALHA] Sistema aceitou pacote ruim! Tecla mudou para %h", Tecla);

        // ------------------------------------------------------------
        // CASO 3: Novo Pacote Válido
        // Endereço: 0000, Tecla: F0, Inverso: 0F
        // ------------------------------------------------------------
        enviar_pacote_38k(16'h0000, 8'hF0, 8'h0F);

        if (Tecla == 8'hF0) 
             $display(">> [SUCESSO] Nova tecla F0 atualizada.");
        else
             $display(">> [FALHA] Tecla F0 nao recebida.");

        #100000;
        $display("--- Fim da Simulacao ---");
        $stop;
    end

endmodule