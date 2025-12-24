module FSM(Clock, Reset, Ready, Load, Clear, Transfer, ReadEnable, WriteEnable, Address);

input Clock, Reset;
output reg Ready, Load, Clear, Transfer, ReadEnable, WriteEnable;
output reg [4:0] Address; // Memória de 32 bits -> 2^5 

// 8 Estados (3 bits)
parameter IDLE         = 3'b000, 
          SEND_ADDR    = 3'b001, 
          WAIT_MEM     = 3'b010,
          LOAD_B       = 3'b011, 
          ACCUMULATE   = 3'b100, 
          WRITE_RESULT = 3'b101,
          NEXT_BLOCK   = 3'b110, 
          DONE         = 3'b111;

reg [2:0] next_state, current_state;
reg [1:0] block_counter; // 4 Blocos (0 a 3) 
reg [2:0] acc_counter;   // Contagem de 7 números (0 a 6) 

always @(*) begin
    Clear = 0; ReadEnable = 0; Load = 0; Ready = 0; 
    Transfer = 0; WriteEnable = 0; Address = 5'b0;
    next_state = current_state;

    case(current_state)
        IDLE: begin
            Clear = 1'b1; // Reseta o Acumulador (Registrador A)
            next_state = SEND_ADDR;
        end

        SEND_ADDR: begin
            ReadEnable = 1'b1;
            Address = (block_counter * 8) + acc_counter;
            next_state = WAIT_MEM;
        end

        WAIT_MEM: begin
            ReadEnable = 1'b1; // Mantém habilitado durante a latência da memória 
            Address = (block_counter * 8) + acc_counter;
            next_state = LOAD_B;
        end

        LOAD_B: begin
            Load = 1'b1; // Pulsa Load para capturar dado no Registrador B
            next_state = ACCUMULATE;
        end

        ACCUMULATE: begin
            Transfer = 1'b1; // Soma B ao Acumulador e armazena em A
            if (acc_counter == 3'd6) // Se completou 7 números
                next_state = WRITE_RESULT;
            else
                next_state = SEND_ADDR;
        end

        WRITE_RESULT: begin
            WriteEnable = 1'b1;
            Address = (block_counter * 8) + 5'd7; // Grava no endereço imediatamente seguinte (7, 15, 23 ou 31)
            next_state = NEXT_BLOCK;
        end

        NEXT_BLOCK: begin
            if (block_counter == 2'd3) // Se processou os 4 conjuntos
                next_state = DONE;
            else
                next_state = IDLE; // Volta ao IDLE para limpar o A e iniciar novo bloco
        end

        DONE: begin
            Ready = 1'b1; // Ativa Ready por pelo menos 1 pulso 
            next_state = IDLE; // Reinicia operação
        end
        
        default: next_state = IDLE;
    endcase
end

always @(posedge Clock) begin
    if (!Reset) begin // Reset Síncrono
        current_state <= IDLE;
        block_counter <= 2'b0;
        acc_counter   <= 3'b0;
    end else begin
        current_state <= next_state;

        if (current_state == ACCUMULATE) begin
            if (acc_counter == 3'd6)
                acc_counter <= 3'b0;
            else
                acc_counter <= acc_counter + 1'b1;
        end

        if (current_state == NEXT_BLOCK) begin
            if (block_counter == 2'd3)
                block_counter <= 2'b0;
            else
                block_counter <= block_counter + 1'b1;
        end
    end
end

endmodule