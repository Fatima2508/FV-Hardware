module signature_analyzer (data_o, clk, reset, valid, data_i);
	input clk, reset, valid;
	input [0:15] data_i;
	output reg [0:15] data_o;

	always @(posedge clk) begin
		if (reset) begin
			data_o <= 16'b0;
		end else begin
			if (valid) begin
				data_o[0] <= data_i[0] ^ data_o[3] ^ data_o[12] ^ data_o[14] ^ data_o[15];
                                data_o[1] <= data_i[1] ^ data_o[0];
                                data_o[2] <= data_i[2] ^ data_o[1];
                                data_o[3] <= data_i[3] ^ data_o[2];
                                data_o[4] <= data_i[4] ^ data_o[3];
                                data_o[5] <= data_i[5] ^ data_o[4];
                                data_o[6] <= data_i[6] ^ data_o[5];
                                data_o[7] <= data_i[7] ^ data_o[6];
                                data_o[8] <= data_i[8] ^ data_o[7];
                                data_o[9] <= data_i[9] ^ data_o[8];
                                data_o[10] <= data_i[10] ^ data_o[9];
                                data_o[11] <= data_i[11] ^ data_o[10];
                                data_o[12] <= data_i[12] ^ data_o[11];
                                data_o[13] <= data_i[13] ^ data_o[12];
                                data_o[14] <= data_i[14] ^ data_o[13];
                                data_o[15] <= data_i[15] ^ data_o[14];
			end else begin
				data_o[0] <= data_o[3] ^ data_o[12] ^ data_o[14] ^ data_o[15];
				data_o[1] <= data_o[0];
				data_o[2] <= data_o[1];
				data_o[3] <= data_o[2];
				data_o[4] <= data_o[3];
				data_o[5] <= data_o[4];
				data_o[6] <= data_o[5];
				data_o[7] <= data_o[6];
				data_o[8] <= data_o[7];
				data_o[9] <= data_o[8];
				data_o[10] <= data_o[9];
				data_o[11] <= data_o[10];
				data_o[12] <= data_o[11];
				data_o[13] <= data_o[12];
				data_o[14] <= data_o[13];
				data_o[15] <= data_o[14];
			end
		end
	end
endmodule
