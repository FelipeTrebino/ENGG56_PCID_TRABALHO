# 1. Clock principal
create_clock -name "main_clk" -period 20.000 [get_ports {Clock}]

# 2. Clocks gerados usando as portas de saída da FSM (hierarquia fsm)
# Nota: Usamos get_pins porque Load/Transfer são lógica combinacional no seu código
create_generated_clock -name "clk_load" -source [get_ports {Clock}] [get_pins {fsm|Load}]
create_generated_clock -name "clk_transfer" -source [get_ports {Clock}] [get_pins {fsm|Transfer}]

# 3. Analisar incertezas
derive_clock_uncertainty