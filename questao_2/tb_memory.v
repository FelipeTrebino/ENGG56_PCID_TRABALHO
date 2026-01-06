`timescale 1ns/1ns

module Testbench_Memory();

    // Sinais de controle e status
    reg Clock, Reset;
    wire Ready;
    
    // Conexões de interface com a Memória e o TOP
    wire [4:0] Address;
    wire ReadEnable, WriteEnable;
    wire [15:0] Data_To_Mem;   
    wire [15:0] Data_From_Mem; // Alterado para wire

    // 1. Instanciação do módulo TOP (Caminho de Dados + FSM)
    TOP dut (
        .Clock(Clock),
        .Reset(Reset),
        .Ready(Ready),
        .DataIN(Data_To_Mem),   // Dados saindo do Acumulador para a RAM
        .Address(Address),
        .ReadEnable(ReadEnable),
        .WriteEnable(WriteEnable),
        .DataOut(Data_From_Mem) // Dados entrando no Acumulador vindos da RAM
    );

    // 2. Instanciação da Memória RAM criada no Quartus (VHDL)
    memory sram_inst (
        .address(Address),
        .clock(Clock),
        .data(Data_To_Mem),
        .rden(ReadEnable),
        .wren(WriteEnable),
        .q(Data_From_Mem)
    );

    // Gerador de Clock (50MHz -> Período de 20ns)
    always #10 Clock = ~Clock;

    initial begin
        // Inicialização
        Clock = 0;
        Reset = 0; // Reset ativo em nível baixo (síncrono na sua FSM)
        
        $display("--- Iniciando Simulação com Memória IP Quartus ---");

        // Procedimento de Reset
        #25 Reset = 1; // Desativa o reset
        #20 Reset = 0; // Pulsa reset
        #20 Reset = 1;

        // Aguarda o sinal Ready da FSM
        wait(Ready == 1);
        
        $display("Simulação Concluída com Sucesso");
        
        // Nota: Como a memória agora é um componente interno, 
        // a visualização direta do conteúdo via 'sram[i]' no testbench 
        // exigiria o uso de caminhos hierárquicos ou monitoramento de sinais.
        
        #100 $stop;
    end

    initial begin
        #2800;
        $stop;
    end

endmodule