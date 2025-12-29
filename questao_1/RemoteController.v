module RemoteController (
    input wire Clock,
    input wire Reset,
    input wire Serial,
    output reg [7:0] Tecla,
    output reg Ready
);

    // --- Definição dos Estados usando PARAMETER ---
    // Isso facilita a leitura e depuração na simulação (o nome aparece na waveform)
    parameter IDLE      = 2'b00; // Estado de espera (linha em repouso)
    parameter READ_DATA = 2'b01; // Estado de leitura dos 32 bits de dados
    parameter CHECK     = 2'b10; // Estado de verificação de integridade
    parameter OUTPUT    = 2'b11; // Estado de envio do sinal de pronto

    // Variáveis de Estado
    reg [1:0] state;

    // Registradores Internos (Datapath)
    reg [31:0] shifter;    // Armazena: Custom(16) + Key(8) + InvKey(8)
    reg [5:0]  bit_cnt;    // Contador de bits (precisa ir até 32)
    reg [1:0]  pulse_cnt;  // Contador para os 3 pulsos de saída

    // Lógica Sequencial da FSM
    always @(posedge Clock or posedge Reset) begin
        if (Reset) begin
            // Reset assíncrono: zera tudo
            state     <= IDLE;
            shifter   <= 32'd0;
            bit_cnt   <= 6'd0;
            pulse_cnt <= 2'd0;
            Ready     <= 1'b0;
            Tecla     <= 8'd0;
        end else begin
            case (state)
                
                // ---------------------------------------------------------
                // 1. IDLE: Espera o Lead Code (Start Bit = 0)
                // ---------------------------------------------------------
                IDLE: begin
                    Ready <= 1'b0;      // Garante que Ready está baixo
                    pulse_cnt <= 2'd0;  // Reseta contador de pulso
                    
                    // O protocolo diz que Default é 1. O início é quando cai para 0.
                    if (Serial == 1'b0) begin
                        state   <= READ_DATA;
                        bit_cnt <= 6'd0; // Prepara para contar 32 bits
                    end
                end

                // ---------------------------------------------------------
                // 2. READ_DATA: Captura serialmente 32 bits
                // ---------------------------------------------------------
                READ_DATA: begin
                    // Shift Register: Entra pela direita (LSB), empurra para esquerda
                    shifter <= {shifter[30:0], Serial};
                    
                    // Incrementa contador
                    bit_cnt <= bit_cnt + 1'b1;

                    // Se já leu 31 (0 a 31 = 32 bits), vai para checagem
                    if (bit_cnt == 6'd31) begin
                        state <= CHECK;
                    end
                end

                // ---------------------------------------------------------
                // 3. CHECK: Validação Lógica (Key == ~InvKey)
                // ---------------------------------------------------------
                CHECK: begin
                    // Layout do Shifter após a leitura:
                    // bits [31:16] = Custom Code (Ignoramos o valor)
                    // bits [15:8]  = Key Code (O que queremos)
                    // bits [7:0]   = Inv Key Code (Para checar erro)

                    // A regra do enunciado é: Key e InvKey devem ser opostos
                    if (shifter[15:8] == ~shifter[7:0]) begin
                        Tecla <= shifter[15:8]; // Salva a tecla válida
                        Ready <= 1'b1;          // Liga o aviso
                        state <= OUTPUT;        // Vai para o estado de saída
                    end else begin
                        // Se falhou na validação (ruído), volta para esperar sem fazer nada
                        state <= IDLE;
                    end
                end

                // ---------------------------------------------------------
                // 4. OUTPUT: Segura o Ready por 3 clocks
                // ---------------------------------------------------------
                OUTPUT: begin
                    // O enunciado pede: "Ready deverá ser ativada por 3 pulsos"
                    // Já ativamos 1 pulso na transição anterior (CHECK->OUTPUT)
                    // Agora contamos mais 2 clocks aqui.
                    
                    if (pulse_cnt < 2'd2) begin
                        pulse_cnt <= pulse_cnt + 1'b1;
                        Ready     <= 1'b1; // Mantém ligado
                    end else begin
                        Ready     <= 1'b0; // Desliga
                        state     <= IDLE; // Fim do ciclo, volta a esperar
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule