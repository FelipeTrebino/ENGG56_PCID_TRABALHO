module RemoteController (
    input wire Clock,
    input wire Reset,     // Reset Assíncrono (Externo)
    input wire Serial,    // Entrada Serial Assíncrona
    output reg [7:0] Tecla,
    output reg Ready
);

    // =========================================================================
    // 1. RESET SYNCHRONIZER
    // Transforma o reset externo assíncrono em um reset síncrono interno.
    // =========================================================================
    reg rst_ff1, rst_ff2;
    wire sys_rst; // Este é o reset que o resto do circuito vai usar

    // Estrutura: "Assert Asynchronously, Deassert Synchronously"
    always @(posedge Clock or posedge Reset) begin
        if (Reset) begin
            rst_ff1 <= 1'b1;
            rst_ff2 <= 1'b1;
        end else begin
            rst_ff1 <= 1'b0;
            rst_ff2 <= rst_ff1;
        end
    end
    
    assign sys_rst = rst_ff2; // Sinal limpo para o sistema

    // =========================================================================
    // 2. DETECTOR DE BORDA (Sincronizador de Entrada)
    // Baseado no seu desenho: FF1 -> FF2(Nov) -> FF3(Ant) -> Lógica AND
    // =========================================================================
    reg ff1;
    reg nov;      // Sinal Atual Estável
    reg ant;      // Sinal Anterior (atrasado em 1 clock)
    wire falling_edge;

    always @(posedge Clock) begin
        if (sys_rst) begin
            ff1 <= 1'b1; // Reset para 1 (Repouso do IR é High)
            nov <= 1'b1;
            ant <= 1'b1;
        end else begin
            ff1 <= Serial; // Estágio 1 de sincronização
            nov <= ff1;    // Estágio 2 (Sinal limpo)
            ant <= nov;    // Memória do estado anterior
        end
    end

    // Lógica Combinacional do Detector: (Ant == 1) AND (Nov == 0)
    assign falling_edge = (~nov & ant);


    // =========================================================================
    // 3. MÁQUINA DE ESTADOS FINITOS (FSM)
    // =========================================================================
    
    // Parâmetros de Estado
    parameter IDLE      = 2'b00;
    parameter READ_DATA = 2'b01;
    parameter CHECK     = 2'b10;
    parameter OUTPUT    = 2'b11;

    reg [1:0] current_state, next_state;

    // Registradores de Dados (Datapath)
    reg [31:0] shift_register;
    reg [5:0]  bit_cnt;
    reg [1:0]  pulse_cnt;

    // Fios auxiliares para leitura do pacote (Baseado no PDF)
    wire [7:0] DataCode        = shift_register[15:8];
    wire [7:0] InverseDataCode = shift_register[7:0];

    // -------------------------------------------------------------------------
    // A) Memória de Estado (Sequencial)
    // Atualiza o estado atual na borda do clock
    // -------------------------------------------------------------------------
    always @(posedge Clock) begin
        if (sys_rst) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // -------------------------------------------------------------------------
    // B) Codificador de Próximo Estado (Combinacional)
    // Decide para onde ir baseado no estado atual e nas entradas
    // -------------------------------------------------------------------------
    always @(*) begin
        // Valor padrão para evitar latches
        next_state = current_state;

        case (current_state)
            IDLE: begin
                // Se detectou borda de descida (Start Bit), vai ler
                if (falling_edge) 
                    next_state = READ_DATA;
                else
                    next_state = IDLE;
            end

            READ_DATA: begin
                // Se já leu 32 bits (0 a 31), vai checar
                if (bit_cnt == 6'd31) 
                    next_state = CHECK;
                else
                    next_state = READ_DATA;
            end

            CHECK: begin
                // Verifica integridade: Dado == ~Inverso
                if (DataCode == ~InverseDataCode)
                    next_state = OUTPUT;
                else
                    next_state = IDLE; // Erro: volta para o início
            end

            OUTPUT: begin
                // Conta 3 pulsos (0, 1, 2) e sai
                if (pulse_cnt == 2'd2)
                    next_state = IDLE;
                else
                    next_state = OUTPUT;
            end
            
            default: next_state = IDLE;
        endcase
    end

    always @(*) begin
        if (current_state == OUTPUT)
            Ready = 1'b1;
            Tecla = DataCode;
        else
            Tecla = 8'd0;
            Ready = 1'b0;
    end
    // -------------------------------------------------------------------------
    // C) Lógica de Saída e Datapath (Sequencial)
    // Controla os registradores, contadores e saídas
    // -------------------------------------------------------------------------
    always @(posedge Clock) begin
        if (sys_rst) begin
            shift_register <= 32'd0;
            bit_cnt        <= 6'd0;
            pulse_cnt      <= 2'd0;
            //Ready          <= 1'b0;
            //Tecla          <= 8'd0;
        end else begin
            case (current_state)
                IDLE: begin
                    //Ready     <= 1'b0;
                    pulse_cnt <= 2'd0;
                    bit_cnt   <= 6'd0;
                    // O shift_register não precisa ser zerado, será sobrescrito
                end

                READ_DATA: begin
                    // IMPORTANTE: Aqui usamos o sinal sincronizado 'nov' em vez do 'Serial' bruto
                    shift_register <= {shift_register[30:0], nov};
                    
                    // Incrementa contador apenas se não mudou de estado (lógica simplificada)
                    // Na prática, em FSM de 3 processos, contadores precisam de cuidado.
                    // Aqui, incrementamos incondicionalmente enquanto estivermos em READ_DATA
                    if (bit_cnt < 6'd32) 
                        bit_cnt <= bit_cnt + 1'b1;
                end

                CHECK: begin
                    // Se a validação do próximo estado for passar, já preparamos a Tecla
                    if (DataCode == ~InverseDataCode) begin
                        //Tecla <= DataCode;
                    end
                end

                OUTPUT: begin
                    //Ready <= 1'b1;
                    if (pulse_cnt < 2'd2)
                        pulse_cnt <= pulse_cnt + 1'b1;
                    else
                        //Ready <= 1'b0; // Prepara para desligar na transição
                end
            endcase
        end
    end

endmodule