module DivBox(
	input wire clock,
	input wire reset,
	input wire DIV_CONTROL,
	input signed [31:0] INPUT_A,
	input signed [31:0] INPUT_B,
	output reg signed[31:0] HI,
	output reg signed[31:0] LO,
	output reg DIV0_OUTPUT
);
	reg signed[63:0] DIVISOR;
	reg signed[63:0] REMAINING;
	reg signed[63:0] REMAINING_AUX;
	reg signed[31:0] QUOTIENT;
	reg ON;
	integer CYCLES;
	reg[31:0] AUX_ONE;
	reg[31:0] AUX_TWO;

initial begin
	ON = 1'b0;
	CYCLES = 0;
end

always @(posedge clock) begin
	if (reset == 1) begin
		HI = 32'b0;
		LO = 32'b0;
		REMAINING = 64'b0;
		DIVISOR = 64'b0; 
		CYCLES = 0;
		REMAINING_AUX = 64'b0;
		ON = 1'b0;
		DIV0_OUTPUT = 1'b0;
	end
	
	if (DIV_CONTROL == 1) begin
		DIV0_OUTPUT = 0;
		DIVISOR = { INPUT_B, 32'b0 };
		REMAINING = { 32'b0, INPUT_A };
		REMAINING_AUX = 64'b0;
		QUOTIENT = 32'b0;
		ON = 1'b1;
		
		if (INPUT_B[31] == 1'b1) begin
			AUX_TWO = ~INPUT_B + 1;
			DIVISOR = { AUX_TWO, 32'b0 };
		end
		
		if (INPUT_A[31] == 1'b1) begin
			AUX_ONE = ~INPUT_A + 1;
			REMAINING = { 32'b0, AUX_ONE };
		end
	end
	
	if (ON && INPUT_B == 32'b0) begin
		DIV0_OUTPUT = 1'b1;
		HI = 32'b0;
		LO = 32'b0;
	end
	
	if (ON == 1'b1 && DIV0_OUTPUT == 1'b0) begin		
		if (CYCLES < 33) begin
			REMAINING_AUX = ~DIVISOR + 1;
			CYCLES = CYCLES + 1;
			REMAINING_AUX = REMAINING_AUX + REMAINING;
			case (REMAINING_AUX[63])
					1'b1: begin 
						QUOTIENT = QUOTIENT <<< 1;						
						DIVISOR = DIVISOR >>> 1;
						QUOTIENT[0] = 1'b0;
					end
					1'b0: begin
						QUOTIENT = QUOTIENT <<< 1;
						REMAINING = REMAINING_AUX;
						DIVISOR = DIVISOR >>> 1;
						QUOTIENT[0] = 1'b1;
					end
			endcase
		end
		else begin			
			HI = REMAINING;
			LO = QUOTIENT;
			ON = 1'b0;
			
			if (INPUT_A[31] == 1'b1 && INPUT_B[31] == 1'b1) begin
				HI = ~HI + 1;
			end
			
			else if (INPUT_B[31] == 1'b1) begin
				LO = ~LO + 1;
			end

			else if (INPUT_A[31] == 1'b1) begin
				HI = ~HI + 1;
				LO = ~LO + 1;
			end
		end
	end
end

endmodule 