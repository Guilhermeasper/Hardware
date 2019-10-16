module SignalExtend16to32 (
	input[15:0] INPUT,
	output reg[31:0] EXT_OUTPUT
);

always @(*)
	EXT_OUTPUT <= $signed(INPUT);

endmodule 