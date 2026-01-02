module FSM_Control (Start, Clock, Reset, Ready, u, v, x, y, Active_MAC, Read_Enable, Address);
  // Entradas
  input             Start;
  input             Clock;
  input             Reset;

  // Saídas
  output reg        Ready;
  output reg [2:0]  u;
  output reg [2:0]  v;
  output reg [2:0]  x;
  output reg [2:0]  y;
  output reg        Active_MAC;
  output reg        Read_Enable;
  output reg [5:0]  Address;

  // Registradores internos
  reg [2:0] EstadoAtual, EstadoFuturo;
  reg [2:0] U_Atual, V_Atual;

  // Estados da FSM
  parameter
    Ocioso           = 3'b000,
    LeituraEndereco  = 3'b001,
    EsperaDados      = 3'b010,
    Acumular         = 3'b011,
    AtualizarUeV     = 3'b100,
    Concluido        = 3'b101;
  
  // Variáveis de X e Y, assume fixo já que não é ajustado na entrada
  parameter
    X_Atual = 3'b000,
    Y_Atual = 3'b000;

  // Bloco sincrono com clock
  always @(posedge Clock or posedge Reset)
  begin
    if (Reset)
    begin
      EstadoAtual <= Ocioso;
      U_Atual <= 3'b000;
      V_Atual <= 3'b000;
    end
    else
    begin
      EstadoAtual <= EstadoFuturo;
      case (EstadoFuturo)
        Ocioso:
        begin
          U_Atual <= 3'b000;
          V_Atual <= 3'b000;
        end
        AtualizarUeV:
        begin
          if (V_Atual == 3'b111)
          begin
            V_Atual <= 3'b000;
            U_Atual <= U_Atual + 1;
          end
          else
          begin
            V_Atual <= V_Atual + 1;
          end
        end
        default:
        begin
          // Nenhuma ação necessária
        end
      endcase
    end
  end

  // Bloco combinacional
  always @(*)
  begin
    EstadoFuturo = EstadoAtual;
    Ready = 1'b0;
    u = U_Atual;
    v = V_Atual;
    x = X_Atual;
    y = Y_Atual;
    Active_MAC = 1'b0;
    Read_Enable = 1'b0;
    Address = {U_Atual, V_Atual};

    case (EstadoAtual)
      Ocioso:
      begin
        if (Start)
          EstadoFuturo = LeituraEndereco;
        else
          EstadoFuturo = Ocioso;
      end

      LeituraEndereco:
      begin
        Read_Enable = 1'b1;
        EstadoFuturo = EsperaDados;
      end

      EsperaDados:
      begin
        // Espera o ciclo de leitura dos dados
        EstadoFuturo = Acumular;
      end

      Acumular:
      begin
        // Assume que o acumulador já recebeu os dados necessários para o cálculo em um pulso
        Active_MAC = 1'b1;
        EstadoFuturo = AtualizarUeV;
      end

      AtualizarUeV:
      begin
        if (U_Atual == 3'b000 && V_Atual == 3'b000)
          EstadoFuturo = Concluido;
        else
          EstadoFuturo = LeituraEndereco;
      end

      Concluido:
      begin
        Ready = 1'b1;
	EstadoFuturo = Ocioso;
      end

      default:
      begin
        EstadoFuturo = Ocioso;
      end
    endcase
  end

endmodule
