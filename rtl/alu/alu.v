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
endmodule
