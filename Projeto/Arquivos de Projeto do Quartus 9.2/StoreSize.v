module StoreSize (
	input[31:0] B,
	input[31:0] DATA,
	input[1:0] SS_CONTROL,
	output reg[31:0] WRITE_DATA
);

always @ (*) begin
	if (SS_CONTROL == 2'b00) begin
		WRITE_DATA <= { DATA[31:8], B[7:0] };
	end
	if (SS_CONTROL == 2'b01) begin
		WRITE_DATA <= { DATA[31:16], B[15:0] };
	end
	if (SS_CONTROL == 2'b10) begin
		WRITE_DATA <= B;
	end
end

endmodule 