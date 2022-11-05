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
endmodule
