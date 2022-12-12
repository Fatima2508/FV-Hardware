module core (clk1, clk2, rstn, start, din, valid_in, cin, caddr, cload, dout, valid_out);
    // *** IO ***
    input clk1, clk2, rstn, start;
    input [15:0] din;
    input valid_in;
    input [15:0] cin;
    input [5:0] caddr;
    input cload;
    output [40:0] dout;
    output reg valid_out;

    // *** INTERNAL WIRING ***
    // *** CMEM ***
    wire [15:0] cmem_out;
    wire cmem_wen;
    wire [5:0] cmem_addr_internal;
    wire [5:0] cmem_addr_fsm;
    reg cmem_cen;

    // *** ALU ***
    wire [40:0] alu_sum_out, alu_sum_in;
    wire [15:0] alu_x;
    wire alu_zero;
    reg y_en, y_rstn;

    // *** N & I ***
    wire [13:0] n_out;
    wire [5:0] i_out;
    reg n_en, i_en;
    reg i_rstn, n_rstn;

    // *** FIFO ***
    wire [15:0] fifo_read_data;
    wire [5:0] fifo_index;
    reg fifo_write_en, fifo_rstn;

    // *** FSM ***
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;
    reg [1:0] next_state, curr_state;

    // *** LOGIC ***
    // *** CMEM ***
    assign cmem_wen = ~cload;
    assign cmem_addr_fsm = i_out;
    assign cmem_addr_internal = (cload) ? caddr : cmem_addr_fsm;
    CMEM_W cmem_0 (.Q(cmem_out), .CLK(~clk2), .CEN(cmem_cen), .WEN(cmem_wen),
        .A(cmem_addr_internal), .D(cin));

    // *** ALU ***
    alu alu_0(.sum_out(alu_sum_out), .x(alu_x), .b(cmem_out), .zero(alu_zero),
        .sum_in(alu_sum_in), .clk(clk2));
    REG_N y_n(.D(alu_sum_out), .CLK(clk2), .RESETN(y_rstn),.EN(y_en), .Q(alu_sum_in));
    defparam y_n.N = 41;

    // *** N & I ***
    counter n_0 (.D(14'b0), .clk(clk2), .rstn(n_rstn), .enable(n_en), .Q(n_out));
    defparam n_0.N = 14;
    counter i_0 (.D(6'b0), .clk(clk2), .rstn(i_rstn), .enable(i_en), .Q(i_out));
    defparam i_0.N = 6;

    // *** FIFO ***
    fifo_shift_reg fifo0(.write_data(din), .read_data(fifo_read_data),
        .write_en(fifo_write_en), .write_clk(clk1), .read_clk(~clk2),
        .index(i_out), .fifo_reset(!fifo_rstn));

    // *** FSM ***
    assign alu_zero = (n_out <= i_out) ? 1 : 0;
    assign alu_x = alu_zero ? 16'b0 : fifo_read_data;
    assign dout = alu_sum_in;

    // clk1 edge detection
    reg clk1_delay_meta;
    reg clk1_delay;
    wire clk1_edge_detected;
    always @(posedge clk2) begin
        clk1_delay_meta <= clk1;
        clk1_delay <= clk1_delay_meta;
    end

    assign clk1_edge_detected = clk1 & ~clk1_delay;

    always @(*) begin
        case (curr_state)
            S0: if(start) next_state = S1;
                else next_state = S0;
            S1: if(i_out < 63) begin
                    next_state = S1;
                end else begin
                    next_state = S2;
                end
            S2: next_state = S3;
            S3: if (clk1_edge_detected) begin
                    if (n_out == 16383) begin
                        next_state = S0;
                    end else begin
                        next_state = S1;
                    end
                end else begin
                    next_state = S3;
                end
        endcase
    end

    always @(posedge clk2) begin
        if(!rstn) begin
            curr_state <= S0;
        end else begin
            curr_state <= next_state;
        end
    end

    always @(*) begin
        n_en = 0; n_rstn = 1; i_en = 0; i_rstn = 1; y_en = 0; y_rstn = 1;
        cmem_cen = 0; fifo_write_en = 0; fifo_rstn = 1; valid_out = 0;

        case (curr_state)
            S0: begin
                n_rstn = 0;
                i_rstn = 0;
                y_rstn = 0;
                fifo_rstn = 0;
            end
            S1: begin
                i_en = 1;
                y_en = 1;
            end
            S2: begin
                n_en = 1;
                i_rstn = 0;
                valid_out = 1;
            end
            S3: begin
                fifo_write_en = 1;
                valid_out = 1;
                if(next_state <= S1) begin
                    y_rstn = 0;
                end else begin
                    y_rstn = 1;
                end
            end
        endcase
    end
endmodule
