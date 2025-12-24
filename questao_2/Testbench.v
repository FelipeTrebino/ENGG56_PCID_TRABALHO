`timescale 1ns/1ps

module Testbench();

    // Sinais para conectar ao TOP
    reg Clock, Reset;
    wire Ready;
    wire [4:0] Address;
    wire ReadEnable, WriteEnable;
    wire [15:0] Data_To_Mem;   
    reg  [15:0] Data_From_Mem;

    // Modelo de Memória SRAM (32 endereços de 16 bits)
    reg [15:0] sram [0:31];
    integer i;

    // Instanciação do módulo TOP
    TOP dut (
        .Clock(Clock),
        .Reset(Reset),
        .Ready(Ready),
        .DataIN(Data_To_Mem),
        .Address(Address),
        .ReadEnable(ReadEnable),
        .WriteEnable(WriteEnable),
        .DataOut(Data_From_Mem)
    );

    // Gerador de Clock
    always #10 Clock = ~Clock;

    // Lógica da Memória
    always @(posedge Clock) begin
        if (ReadEnable) begin
            Data_From_Mem <= sram[Address];
            $display("[LEITURA] Endereço: %0d | Valor: %0h", Address, sram[Address]);
        end
        else if (WriteEnable) begin
            sram[Address] <= Data_To_Mem;
            $display("[ESCRITA] Endereço: %0d | Valor: %0h", Address, Data_To_Mem);
        end
    end

    initial begin
        // 1. Inicialização de Sinais
        Clock = 0;
        Reset = 1;
        
        // 2. Carrega dados do arquivo para a SRAM
        $readmemh("C:/Users/flip_/Documents/GitHub/ENGG56_PCID_TRABALHO/questao_2/memory.txt", sram); 
        $display("--- Dados da Memória Carregados do Arquivo ---");

        // 3. Procedimento de Reset
        #25 Reset = 0;
        #20 Reset = 1;

        // 4. Aguarda o sinal Ready
        wait(Ready == 1);
        
        $display("Simulação Concluída");
        $display("Resultado Bloco 1 (End 7):  %0d", sram[7]);
        $display("Resultado Bloco 2 (End 15): %0d", sram[15]);
        $display("Resultado Bloco 3 (End 23): %0d", sram[23]);
        $display("Resultado Bloco 4 (End 31): %0d", sram[31]);

        #100 $stop;
    end

endmodule