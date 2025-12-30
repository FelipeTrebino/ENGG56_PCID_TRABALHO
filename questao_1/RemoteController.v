module RemoteController (
    input wire Clock,     // 304 kHz
    input wire Reset,     // Reset Assíncrono
    input wire Serial,    // 38 kHz (Dados)
    output reg [7:0] Tecla,
    output reg Ready
);

    // =========================================================================
    // 0. DEFINIÇÕES GERAIS (Movido para o topo para evitar erros)
    // =========================================================================
    
    // Parâmetros de Estado
    parameter IDLE      = 2'b00;
    parameter READ_DATA = 2'b01;
    parameter CHECK     = 2'b10;
    parameter OUTPUT    = 2'b11;

    // Registradores de Estado
    reg [1:0] current_state, next_state;

    // =========================================================================
    // 1. RESET SYNCHRONIZER
    // =========================================================================
    reg rst_ff1, rst_ff2;
    wire sys_rst;

    always @(posedge Clock or posedge Reset) begin
        if (Reset) begin
            rst_ff1 <= 1'b1;
            rst_ff2 <= 1'b1;
        end else begin
            rst_ff1 <= 1'b0;
            rst_ff2 <= rst_ff1;
        end
    end
    assign sys_rst = rst_ff2;

    // =========================================================================
    // 2. DETECTOR DE BORDA E SINCRONIZADOR
    // =========================================================================
    reg ff1, nov, ant;
    wire falling_edge;

    always @(posedge Clock) begin
        if (sys_rst) begin
            ff1 <= 1'b1;
            nov <= 1'b1;
            ant <= 1'b1;
        end else begin
            ff1 <= Serial;
            nov <= ff1;
            ant <= nov;
        end
    end
    
    // Detecta quando o sinal cai de 1 para 0
    assign falling_edge = (~nov & ant);

    // =========================================================================
    // 3. GERADOR DE BAUD RATE (DIVISOR DE FREQUÊNCIA)
    // =========================================================================
    // Agora este bloco vai compilar porque 'current_state' e 'IDLE' 
    // já foram declarados lá no topo (Bloco 0).
    
    reg [2:0] baud_cnt;   
    wire sample_tick;     

    assign sample_tick = (baud_cnt == 3'd3);

    always @(posedge Clock) begin
        if (sys_rst) begin
            baud_cnt <= 3'd0;
        end else begin
            // Reseta contador se detectar borda no estado IDLE
            if (falling_edge && current_state == IDLE) 
                baud_cnt <= 3'd0;
            else
                baud_cnt <= baud_cnt + 1'b1;
        end
    end

    // =========================================================================
    // 4. MÁQUINA DE ESTADOS FINITOS (FSM) - LÓGICA
    // =========================================================================
    
    // Datapath
    reg [31:0] shift_register;
    reg [5:0]  bit_cnt;
    reg [1:0]  pulse_cnt;

    wire [7:0] DataCode        = shift_register[15:8];
    wire [7:0] InverseDataCode = shift_register[7:0];

    // A) Atualização de Estado
    always @(posedge Clock) begin
        if (sys_rst) current_state <= IDLE;
        else         current_state <= next_state;
    end

    // B) Lógica de Próximo Estado
    always @(*) begin
        next_state = current_state; 
        case (current_state)
            IDLE: begin
                if (falling_edge) next_state = READ_DATA;
                else              next_state = IDLE;
            end

            READ_DATA: begin
                if (bit_cnt == 6'd32) next_state = CHECK;
                else                  next_state = READ_DATA;
            end

            CHECK: begin
                if (DataCode == ~InverseDataCode) next_state = OUTPUT;
                else                              next_state = IDLE;
            end

            OUTPUT: begin
                if (pulse_cnt == 2'd2) next_state = IDLE;
                else                   next_state = OUTPUT;
            end
            
            default: next_state = IDLE;
        endcase
    end

    // C) Saída Combinacional (Ready)
    always @(*) begin
        if (current_state == OUTPUT) Ready = 1'b1;
        else                         Ready = 1'b0;
    end

    // D) Datapath Sequencial
    always @(posedge Clock) begin
        if (sys_rst) begin
            shift_register <= 32'd0;
            bit_cnt        <= 6'd0;
            pulse_cnt      <= 2'd0;
            Tecla          <= 8'd0;
        end else begin
            case (current_state)
                IDLE: begin
                    pulse_cnt <= 2'd0;
                    bit_cnt   <= 6'd0;
                end

                READ_DATA: begin
                    if (sample_tick) begin
                        shift_register <= {shift_register[30:0], nov};
                        if (bit_cnt < 6'd32)
                            bit_cnt <= bit_cnt + 1'b1;
                    end
                end

                CHECK: begin
                    if (DataCode == ~InverseDataCode) begin
                        Tecla <= DataCode;
                    end
                end

                OUTPUT: begin
                    if (pulse_cnt < 2'd2)
                        pulse_cnt <= pulse_cnt + 1'b1;
                end
            endcase
        end
    end

endmodule