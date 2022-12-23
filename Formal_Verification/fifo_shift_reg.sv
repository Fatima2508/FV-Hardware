module fifo_shift_reg (write_data, read_data, write_en, write_clk, read_clk, index, fifo_reset);
    // *** PARAMETERS ***
    parameter BIT_WIDTH = 16; // Bit width of each word
    parameter NUM_WORDS = 64; // Number of words in memory
    parameter ADDR_WIDTH = 6; // Number of address bits

    // *** IO ***
    input [BIT_WIDTH-1:0] write_data;
    input write_en, write_clk, read_clk, fifo_reset;
    input [ADDR_WIDTH-1:0] index;

    output [BIT_WIDTH-1:0] read_data;

    // *** INTERNAL REG ***
    reg [BIT_WIDTH-1:0] reg_file [0:NUM_WORDS - 1]; 
    reg [ADDR_WIDTH-1:0] read_addr;
    integer i;

    // *** LOGIC ***
    assign read_data = reg_file[read_addr];

    always @(posedge read_clk) begin
        if (fifo_reset) begin
            read_addr <= 0;
        end else begin
            read_addr <= index;
        end
    end

    always @(posedge write_clk) begin
        if (write_en) begin
            reg_file[0] <= write_data;
            for (i = 1; i < NUM_WORDS; i = i + 1) begin
                reg_file[i] <= reg_file[i - 1];
            end
        end
    end
    wire fire1;
    wire fire2;
    
    ovl_no_overflow #( .width(ADDR_WIDTH)) no_overflow (.clock(write_clk), .reset(fifo_reset), .enable(write_en), .test_expr(index), .fire(fire1));

    ovl_no_underflow #( .width(ADDR_WIDTH)) no_underflow (.clock(read_clk), .reset(fifo_reset), .enable(1'b1), .test_expr(index), .fire(fire2));


    //default clocking c0 @(posedge read_clk); endclocking
    property reset_raddr0;
	 @(posedge read_clk)
	 	(fifo_reset |-> (read_addr==0));
    endproperty
   
    property reset_rdata0;
	 @(posedge read_clk)
	 	(fifo_reset |-> (read_data==0));
    endproperty

    property fifo_full;
	 @(posedge write_clk)
	 	((fifo_reset && !write_en) |-> ##1 $stable(read_data));
    endproperty

    check_rst_raddr: assert property (reset_raddr0);
    check_rst_rdata: assert property (reset_rdata0);
    check_fifo_full: assert property (fifo_full);

    default clocking c0 @(posedge read_clk); endclocking
    rdata_never_x: assert property (^read_data !== 16'hxxxx);
    fifo_cover_0: cover property (index == 64);
    fifo_cover_1: cover property (index == 63);
    fifo_cover_2: cover property (index == 0);


    
endmodule
