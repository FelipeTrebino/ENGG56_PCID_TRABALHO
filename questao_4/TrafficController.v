module TrafficController (
    input wire A,
    input wire B,
    input wire C,
    input wire D,
    output wire L_O,
    output wire N_S
);
    assign L_O = C | D | (~A & ~B);
    assign N_S = ~L_O;

endmodule