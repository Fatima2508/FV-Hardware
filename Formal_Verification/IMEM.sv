module IMEM (Q, CLK, CEN, WEN, A, D);
    // I/O
    output [15:0] Q;
    input CLK;
    input CEN;
    input WEN;
    input [13:0] A;
    input [15:0] D;

    // Internal control
    reg [63:0] WEN_internal;
    reg [63:0] CEN_internal;

    // Internal Q
    wire [15:0] Q_internal [63:0];

    // Individual WEN computation
    always @(*) begin
        // Default
        WEN_internal = ~0;

        if(~WEN) begin
            // One hot
            WEN_internal[A[13:8]] = 0;
        end
    end

    // Individual CEN computation
    always @(*) begin
        // Default
        CEN_internal = ~0;

        if(~CEN) begin
            CEN_internal[A[13:8]] = 0;
        end
    end

    assign Q = Q_internal[A[13:8]];

    genvar k;
    generate
        for(k = 0; k < 64; k = k + 1) begin
            IMEM_256 imem_n(.Q(Q_internal[k]), .CLK(CLK), .CEN(CEN_internal[k]),
                .WEN(WEN_internal[k]), .A(A[7:0]), .D(D));
        end
    endgenerate
endmodule
