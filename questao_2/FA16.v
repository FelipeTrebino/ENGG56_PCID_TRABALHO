module FA16(CIn, COut, A, B, S);

    input [15:0] A,B; 
    input  CIn;
    output COut;
    output [15:0] S; 

    wire C4, C8, C12;

    FA4 fa4_0(
        .CIn(CIn), 
        .COut(C4), 
        .A(A[3:0]), 
        .B(B[3:0]), 
        .S(S[3:0])
    );
    

    FA4 fa4_1(
        .CIn(C4), 
        .COut(C8), 
        .A(A[7:4]), 
        .B(B[7:4]), 
        .S(S[7:4])
    );
    
    FA4 fa4_2(
        .CIn(C8), 
        .COut(C12), 
        .A(A[11:8]), 
        .B(B[11:8]), 
        .S(S[11:8])
    );
    
    FA4 fa4_3(
        .CIn(C12), 
        .COut(COut), 
        .A(A[15:12]), 
        .B(B[15:12]), 
        .S(S[15:12])
    );

endmodule