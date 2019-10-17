module SignalExtend26to32 (
	input[25:0] INPUT,
	output reg[31:0] EXT_OUTPUT
);

always @(*)
	EXT_OUTPUT <= $signed(INPUT);

endmodule 