module CMEM_W(Q, CLK, CEN, WEN, A, D); 
    output [15:0] Q;
    input         CLK;
    input         CEN;
    input         WEN;
    input [5:0]   A;
    input [15:0]  D;

    CMEM cmem_inst (.Q(Q), .CLK(CLK), .CEN(CEN), .WEN(WEN), .A(A), .D(D));
endmodule
