module SignalExtend1to32 (
	input INPUT,
	output reg[31:0] EXT_OUTPUT
);

always @(*)
	EXT_OUTPUT <= $signed(INPUT);

endmodule 