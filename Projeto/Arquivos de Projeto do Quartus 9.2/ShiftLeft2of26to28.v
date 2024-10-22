module ShiftLeft2of26to28 (
	input[25:0] SL2_26_INPUT,
	input[3:0] PC_31to28_INPUT,
	output reg[31:0] SL2_32_OUTPUT
	
);

always @(*)
	SL2_32_OUTPUT <= { PC_31to28_INPUT, SL2_26_INPUT, 2'b0 };

endmodule 