module counter (D, clk, rstn, enable, Q);
    parameter N = 16;
    input [N-1:0] D;
    input clk, rstn, enable;
    output [N-1:0] Q;

    reg [N-1:0] Q_INT;

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            // Asynchronous reset
            Q_INT <= 0;
        end else begin
            if (enable) begin
                Q_INT <= Q_INT + 1;
            end else begin
                Q_INT <= Q_INT;
            end
        end
    end

    assign Q = Q_INT;
endmodule
