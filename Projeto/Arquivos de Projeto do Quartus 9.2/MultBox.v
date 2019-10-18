module MultBox (
	input wire clock,
	input wire reset,
	input wire MULT_CONTROL,
	input wire[31:0] INPUT_A,
	input wire[31:0] INPUT_B,
	output reg[31:0] HI,
	output reg[31:0] LO
);
	
	reg[64:0] A, P;
	integer S;
	
	always @(posedge clock) begin
		if (reset == 1) begin
			A = 65'b0;
			S = 0;
			P = 65'b0;
			HI = 32'b0;
			LO = 32'b0;
		end
		
		if (MULT_CONTROL == 1) begin
			A = { INPUT_A, 33'b0 };
			S = 0;
			P = { 32'b0, INPUT_B, 1'b0 };
			HI = 32'b0;
			LO = 32'b0;
		end

		case (P[1:0])
			2'b00: begin
				if (S < 32) begin
					P = P >> 1;
					S = S + 1;
				end
			end
			2'b01: begin
				if (S < 32) begin
					P = P + A;
					P = P >> 1;
					S = S + 1;
				end
			end
			2'b10: begin
				if (S < 32) begin
					P = P - A;
					P = P >> 1;
					S = S + 1;
				end
			end
			2'b11: begin
				if (S < 32) begin
					P = P >> 1;
					S = S + 1;
				end
			end
		endcase

		if (P[63] == 1) begin
			P[64] = 1;
		end

		if (S == 32) begin
			HI = P[64:33];
			LO = P[32:1];
		end
	end
endmodule 