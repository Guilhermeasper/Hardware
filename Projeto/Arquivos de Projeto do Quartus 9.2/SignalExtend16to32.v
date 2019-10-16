module SignalExtend16to32 (
	input[15:0] INPUT,
	output reg[31:0] EXTENDED_OUTPUT
);

always @(*)
	EXTENDED_OUTPUT <= $signed(INPUT);

endmodule 