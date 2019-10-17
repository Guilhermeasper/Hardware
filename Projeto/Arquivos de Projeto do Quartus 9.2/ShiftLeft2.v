module ShiftLeft2 (
	input[31:0] SL2_INPUT,
	output reg[31:0] SL2_OUTPUT
);

always @(*)
	SL2_OUTPUT <= SL2_INPUT << 2;

endmodule 