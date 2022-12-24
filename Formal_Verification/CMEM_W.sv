module CMEM_W(Q, CLK, CEN, WEN, A, D); 
    output [15:0] Q;
    input         CLK;
    input         CEN;
    input         WEN;
    input [5:0]   A;
    input [15:0]  D;

    parameter MAX_ADDR = 6'b111111;
    CMEM cmem_inst (.Q(Q), .CLK(CLK), .CEN(CEN), .WEN(WEN), .A(A), .D(D));

    property address_in_range;
        @(posedge CLK) 
           (A >= 0) && (A <= MAX_ADDR);
    endproperty
    address_in_range_1: assert property (address_in_range);

    property address_known;
        @(posedge CLK) 
            (CEN || WEN) |-> !$isunknown(A); //CEN is always 0 in core
    endproperty 
    address_known_1: assert property (address_known);

    property data_known;
        @(posedge CLK) 
            (WEN) |-> !$isunknown(D);
    endproperty 
    data_known_1: assert property (data_known);
endmodule
