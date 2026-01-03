module FSM_Control (Start, Clock, Reset, Ready, u, v, x, y, Active_MAC, Read_Enable, Address);
  // Entradas
  input             Start;
  input             Clock;
  input             Reset;

  // Saídas
  output        Ready;
  output [2:0]  u;
  output [2:0]  v;
  output [2:0]  x;
  output [2:0]  y;
  output        Active_MAC;
  output        Read_Enable;
  output [5:0]  Address;

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


  // Atribuições de saídas
  assign Ready = (EstadoAtual == Concluido);
  assign u = U_Atual;
  assign v = V_Atual;
  assign x = X_Atual;
  assign y = Y_Atual;
  assign Active_MAC = (EstadoAtual == Acumular);
  assign Read_Enable = (EstadoAtual == LeituraEndereco);
  assign Address = {U_Atual, V_Atual};

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

  // Bloco decodificador de proximo estado, assincrono
  always @(*)
  begin
    EstadoFuturo = EstadoAtual;
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
			EstadoFuturo = Ocioso;
      end

      default:
      begin
        EstadoFuturo = Ocioso;
      end
    endcase
  end

endmodule
