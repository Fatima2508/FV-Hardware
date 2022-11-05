`timescale 1ns/1ps
`define SD 0.010
`define HALF_CLOCK_PERIOD_READ 250    // 2MHz
`define QUARTER_CLOCK_PERIOD_READ 125    // 2MHz
`define HALF_CLOCK_PERIOD_WRITE 50000 // 10kHz
`define QSIM_OUT_FN "./qsim.out"
`define MATLAB_OUT_FN_CMEM "../../matlab/fir/random_gen_b.result"
`define MATLAB_OUT_FN_IMEM "../../matlab/fir/random_gen_x.result"
`define MATLAB_OUT_FN_FIR "../../matlab/fir/fir_m.result"

module testbench();
    reg clk1, clk2, rstn, start;
    reg [15:0] din;
    reg valid_in;
    reg [15:0] cin;
    reg [5:0] caddr;
    reg cload;
    wire [31:0] dout;
    wire valid_out;

    integer i, j;
    integer ret_read;
    integer matlab_out_file_CMEM;
    integer matlab_out_file_IMEM;
    integer matlab_out_file_FIR;
    integer fir_expected_out;
    integer error_count = 0;

    core core_0(.clk1(clk1), .clk2(clk2), .rstn(rstn), .start(start), .din(din),
        .valid_in(valid_in), .cin(cin), .caddr(caddr), .cload(cload), .dout(dout),
        .valid_out(valid_out));

    always begin
        #`QUARTER_CLOCK_PERIOD_READ
        clk2 = 0'b1;
        forever clk2 = #`HALF_CLOCK_PERIOD_READ ~clk2;
    end

    always begin
        clk1 = 0'b1;
        forever clk1 = #`HALF_CLOCK_PERIOD_WRITE ~clk1;
    end

    initial begin
        matlab_out_file_CMEM = $fopen(`MATLAB_OUT_FN_CMEM, "r");
        matlab_out_file_IMEM = $fopen(`MATLAB_OUT_FN_IMEM, "r");
        matlab_out_file_FIR = $fopen(`MATLAB_OUT_FN_FIR, "r");

        if(!matlab_out_file_CMEM) begin
            $display("Couldn't read the CMEM MATLAB file.");
            $finish;
        end

        if(!matlab_out_file_IMEM) begin
            $display("Couldn't read the IMEM MATLAB file.");
            $finish;
        end

        if(!matlab_out_file_FIR) begin
            $display("Couldn't read the FIR MATLAB file.");
            $finish;
        end

        $dumpfile("./core_short.vcd");
        $dumpvars(0, testbench.core_0);

        // Start test
        clk1 = 0;
        clk2 = 0;
        rstn = 0;
        start = 0;

        @(posedge clk2)
        @(posedge clk2)

        // Write coefficients to CMEM loop
        cload = 1;
        rstn = 1;
        for (i = 0; i < 64; i = i + 1) begin
            ret_read = $fscanf(matlab_out_file_CMEM, "%d", cin);
            caddr = i;
            @(posedge clk2);
            @(posedge clk2);
        end

        // Run core loop
        @(negedge clk1)
        cload = 0;
        for (j = 0; j < 256; j = j + 1) begin
            @(negedge clk1)
            ret_read = $fscanf(matlab_out_file_IMEM, "%d", din);
            start = 1;
            valid_in = 1;

            @(posedge clk1)
            valid_in = 0;
            if (fir_expected_out !== 32'hx) begin
                if (dout !== fir_expected_out) begin
                    error_count = error_count + 1;
                end
            end
            // Wait a bit so we can check answers
            #500
            ret_read = $fscanf(matlab_out_file_FIR, "%d", fir_expected_out);
        end

        start = 0;

        if (error_count > 0) begin
            $display("The written data does not match the read data! :(");
        end
        else begin
            $display("The written data does match the read data! :) ");
        end

        $dumpall;
        $dumpflush;
        $fclose(matlab_out_file_IMEM);
        $fclose(matlab_out_file_CMEM);
        $fclose(matlab_out_file_FIR);
        $finish;
    end
endmodule
