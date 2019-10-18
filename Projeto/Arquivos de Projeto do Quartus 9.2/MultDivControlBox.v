module MultDivControlBox (
	input wire[1:0] CONTROL_MULTDIV,
	output reg MULT_CONTROL,
	output reg DIV_CONTROL
);

initial begin
	MULT_CONTROL <= 1'b0;
	DIV_CONTROL <= 1'b0;
end

always @ (*) begin
	case (CONTROL_MULTDIV)
		2'b00: begin
			MULT_CONTROL <= 1'b0;
			DIV_CONTROL <= 1'b0;
		end
		2'b01: begin
			MULT_CONTROL <= 1'b1;
			DIV_CONTROL <= 1'b0;
		end
		2'b10: begin
			DIV_CONTROL <= 1'b1;
			MULT_CONTROL <= 1'b0;
		end
		2'b11: begin
			MULT_CONTROL <= 1'b0;
			DIV_CONTROL <= 1'b0;
		end
	endcase
end

endmodule
