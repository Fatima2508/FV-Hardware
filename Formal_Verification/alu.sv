module alu (sum_out, x, b, zero, sum_in, clk);
	input clk;
	input signed [15:0] x, b;
	input zero;
	input signed [40:0] sum_in;
	output wire signed [40:0] sum_out;

	wire signed [31:0] y_temp;
	wire signed [31:0] xb;

	assign y_temp = (zero) ? 32'b0 : xb;
	assign xb = x * b;
	assign sum_out = sum_in + y_temp;

	
	default clocking c0 @(posedge clk); endclocking
    	//check correctness of ALU
	overflow_sum : assert property (sum_out <= 41'h1FFFFFFFFFF);
	x_b_never_x : assert property ((x !== 16'hxxxx) or (b !== 16'hxxxx));
	accuracy_0 : assert property ($signed(xb) == $signed(x) * $signed(b));
	accuracy_1 : assert property ($signed(sum_out) == $signed(sum_in) + $signed(y_temp));

endmodule
