module ShiftLeft16 (
	input[15:0] SL16_INPUT,
	output reg[31:0] SL_32_OUTPUT
);

always @(*)
	SL_32_OUTPUT <= { SL16_INPUT, 16'b0 };

endmodule 