module MultDivMuxBox (
	input wire[1:0] CONTROL_MULTDIV,
	input wire[31:0] HI_MULT,
	input wire[31:0] LO_MULT,
	input wire[31:0] HI_DIV,
	input wire[31:0] LO_DIV,
	output reg[31:0] HI_OUTPUT,
	output reg[31:0] LO_OUTPUT
);

reg[1:0] PREVIOUS_CONTROL;
initial PREVIOUS_CONTROL <= 2'b0;

always @(*) begin

	if (CONTROL_MULTDIV == 2'b01) begin
		HI_OUTPUT <= HI_MULT;
		LO_OUTPUT <= LO_MULT;
		PREVIOUS_CONTROL = 2'b01;
	end
	
	else if (CONTROL_MULTDIV == 2'b10) begin 
		HI_OUTPUT <= HI_DIV;
		LO_OUTPUT <= LO_DIV;
		PREVIOUS_CONTROL = 2'b10;
	end
	
	else begin
		if (PREVIOUS_CONTROL == 2'b00) begin
			HI_OUTPUT <= 32'b0;
			LO_OUTPUT <= 32'b0;
		end
		else if (PREVIOUS_CONTROL == 2'b01) begin
			HI_OUTPUT <= HI_MULT;
			LO_OUTPUT <= LO_MULT;
		end
		else if (PREVIOUS_CONTROL == 2'b10) begin 
			HI_OUTPUT <= HI_DIV;
			LO_OUTPUT <= LO_DIV;
		end
	end
end

endmodule 