module mux1(clock, saida, controle);
	
	input wire clock;
	input wire[1:0] controle;
	output reg[31:0] saida;
	
	parameter selectEntrada0=2'b00;
	parameter selectEntrada1=2'b01;
	parameter selectEntrada2=2'b10;
	
	initial begin
		saida <= 32'b0;
	end
	
	always@(*) begin
		case(controle)
			
			selectEntrada0: begin
				saida <= 32'd253; //253 - opcode inexistente
			end
			
			selectEntrada1: begin
				saida <= 32'd254; //254 - overflow
			end
			
			selectEntrada2: begin
				saida <= 32'd255; //255 - divisao por zero
			end
			
		endcase
	end
endmodule
