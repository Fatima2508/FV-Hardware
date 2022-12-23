module core (clk, rstn, start, din, valid_in, cin, caddr, cload, dout, valid_out);
    // *** IO ***
    input clk, rstn, start;
    input [15:0] din;
    input valid_in;
    input [15:0] cin;
    input [5:0] caddr;
    input cload;
    output [40:0] dout;
    output reg valid_out;

    //slower clock 1
    reg clk1;
    reg [27:0] clk1_counter = 28'd0;
    parameter DIVISOR = 28'd200;

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
    CMEM_W cmem_w_inst (.Q(cmem_out), .CLK(~clk), .CEN(cmem_cen), .WEN(cmem_wen),
        .A(cmem_addr_internal), .D(cin));

    // *** ALU ***
    alu alu_inst(.sum_out(alu_sum_out), .x(alu_x), .b(cmem_out), .zero(alu_zero),
        .sum_in(alu_sum_in), .clk(clk));
    REG_N y_n(.D(alu_sum_out), .CLK(clk), .RESETN(y_rstn),.EN(y_en), .Q(alu_sum_in));
    defparam y_n.N = 41;

    // *** N & I ***
    counter n_inst (.D(14'b0), .clk(clk), .rstn(n_rstn), .enable(n_en), .Q(n_out));
    defparam n_inst.N = 14;
    counter i_inst (.D(6'b0), .clk(clk), .rstn(i_rstn), .enable(i_en), .Q(i_out));
    defparam i_inst.N = 6;

    // *** FIFO ***
    fifo_shift_reg fifo_inst(.write_data(din), .read_data(fifo_read_data),
        .write_en(fifo_write_en), .write_clk(clk1), .read_clk(~clk),
        .index(i_out), .fifo_reset(!fifo_rstn));

    // *** FSM ***
    assign alu_zero = (n_out <= i_out) ? 1 : 0;
    assign alu_x = alu_zero ? 16'b0 : fifo_read_data;
    assign dout = alu_sum_in;

    //slower clk1
    always @(posedge clk)
        begin
        clk1_counter <= clk1_counter + 28'd1;
        if(clk1_counter>=(DIVISOR-1))
            clk1_counter <= 28'd0;
            clk1 <= (clk1_counter<DIVISOR/2)?1'b1:1'b0;
        end
    
    // clk1 edge detection
    reg clk1_delay_meta;
    reg clk1_delay;
    wire clk1_edge_detected;
    always @(posedge clk) begin
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

    always @(posedge clk) begin
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

    default clocking c0 @(posedge clk); endclocking

    //check sequence of states
    state0: assert property ((curr_state == S0) |=> (curr_state == S0 or curr_state == S1));
    state1: assert property ((curr_state == S1) |=> (curr_state == S1 or curr_state == S2));
    state2: assert property ((curr_state == S2) |=> (curr_state == S3));
    state3: assert property ((curr_state == S3) |=> (curr_state == S0 or curr_state == S1 or curr_state == S3));

    //correct state after expected number of cycles once the state machine starts
    state0_1: assert property ((start && (curr_state == S0)) |-> ##1 (curr_state == S1));
    state0_2: assert property ((start && (curr_state == S0)) |-> ##65 (curr_state == S2));
    state0_3: assert property ((start && (curr_state == S0)) |-> ##66 (curr_state == S3));
    

    
    
    // Verify ALU operations 
    alu_y_enabled : assert property ((y_en) |-> ##1 ($past(alu_sum_out) == alu_sum_in)); 
    ai_x_never_x : assert property (^alu_x !== 16'hxxxx);
    ai_b_never_x : assert property (^cmem_out !== 16'hxxxx);
    ao_never_x : assert property (^alu_sum_out !== 41'hXXXXXXXXXXX);

    alu_overflow_msb : assert property ((alu_x[15] == 1 && cmem_out[15] == 1 && !alu_zero && alu_sum_in!==0) |->  ($signed(alu_sum_out) > 41'd65535));
    alu_fir_reset : assert property ((!y_rstn) |-> ##1 (alu_sum_in == 0));

endmodule
