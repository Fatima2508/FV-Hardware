module REG_N (D, CLK, RESETN, EN, Q);
    parameter N = 16;
    input [N-1:0] D;
    input CLK, RESETN, EN;
    output [N-1:0] Q;

    reg [N-1:0] Q_INT;

    always @(posedge CLK) begin
        if(!RESETN) begin
            // Synchronous reset
            Q_INT <= 0;
        end else begin
            if (EN) begin
                Q_INT <= D;
            end else begin
                Q_INT <= Q_INT;
            end
        end
    end

    assign Q = Q_INT;
endmodule
