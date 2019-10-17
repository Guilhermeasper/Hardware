module LoadSize(
	input[31:0] MDR_INPUT,
	input[1:0] LOAD_SIZE_INPUT,
	output reg[31:0] OUTPUT
);

always @ (*) begin
	if (LOAD_SIZE_INPUT == 2'b11) begin
		OUTPUT <= { 24'b0, MDR_INPUT[7:0] };
	end
	if (LOAD_SIZE_INPUT == 2'b10) begin
		OUTPUT <= { 16'b0, MDR_INPUT[15:0] };
	end
	if (LOAD_SIZE_INPUT == 2'b01) begin
		OUTPUT <= MDR_INPUT;
	end
	if (LOAD_SIZE_INPUT == 2'b00) begin
		OUTPUT <= 32'b0;
	end
end

endmodule
