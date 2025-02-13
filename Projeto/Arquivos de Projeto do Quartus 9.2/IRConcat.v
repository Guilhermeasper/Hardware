module IRConcat (
	input wire[15:0] IR_15to0_INPUT,
	input wire[20:16] IR_20to16_INPUT,
	input wire[25:21] IR_25to21_INPUT,
	output reg[25:0] IR_OUTPUT
);

always @ (*)
	IR_OUTPUT <= { IR_25to21_INPUT, IR_20to16_INPUT, IR_15to0_INPUT };

endmodule 