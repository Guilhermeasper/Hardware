module mux1(clock, saida, controle);
	
	input wire clock;
	input wire[1:0] controle;
	output reg[7:0] saida;
	
	parameter selectEntrada0=2'b00;
	parameter selectEntrada1=2'b01;
	parameter selectEntrada2=2'b10;
	
	initial begin
		saida <= 8'b0;
	end
	
	always@(*) begin
		case(controle)
			
			selectEntrada0: begin
				saida <= 8'b11111101; //253
			end
			
			selectEntrada1: begin
				saida <= 8'b11111110; //254
			end
			
			selectEntrada2: begin
				saida <= 8'b11111111; //255
			end
			
		endcase
	end
endmodule
