`timescale 1ns/1ns

module TB_FSM_Control;

  // Entradas
  reg Clock, Reset, Start;

  // Saídas
  wire Ready;
  wire [2:0] u, v, x, y;
  wire Active_MAC;
  wire Read_Enable;
  wire [5:0] Address;

  FSM_Control DUV (
    .Start(Start),
    .Clock(Clock),
    .Reset(Reset),
    .Ready(Ready),
    .u(u),
    .v(v),
    .x(x),
    .y(y),
    .Active_MAC(Active_MAC),
    .Read_Enable(Read_Enable),
    .Address(Address)
  );

  initial Clock = 0;
  always #5
    Clock = ~Clock;

  initial begin
    Reset = 1;
    Start = 0;

    #10;
    Reset = 0;

    #10;
    Start = 1;
    #10;
    Start = 0;

    wait (Ready == 1);
    #20;

    $finish;
  end

  initial begin
    $monitor("Time=%0t | Reset=%b Start=%b | State=%d (u,v)=(%d,%d) | Read_Enable=%b Active_MAC=%b Address=%b Ready=%b",
             $time, Reset, Start, DUV.EstadoAtual, u, v, Read_Enable, Active_MAC, Address, Ready);
  end

endmodule
