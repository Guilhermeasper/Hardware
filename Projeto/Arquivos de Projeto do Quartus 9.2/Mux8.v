module Mux8(clock, entrada0, entrada1, entrada2, controle, saida);
	
	//Iniciando os fio tudo.
	input wire clock;
	input wire [31:0]entrada0;
	input wire [31:0]entrada1;
	input wire [31:0]entrada2;
	input wire [1:0]controle;
	output reg [31:0]saida;

	parameter selectEntrada0=2'b00;
	parameter selectEntrada1=2'b01;
	parameter selectEntrada2=2'b10;
	
	//Setando estado inicial para todos os fios.
	initial begin
		saida <= 32'b0000000000000000;
	end

	always@(*) begin
		case (controle)
			selectEntrada0: begin
				saida <= entrada0;
			end

			selectEntrada1: begin
				saida <= entrada1;
			end

			selectEntrada2: begin
				saida <= entrada2;
			end
		endcase
	end
endmodule 