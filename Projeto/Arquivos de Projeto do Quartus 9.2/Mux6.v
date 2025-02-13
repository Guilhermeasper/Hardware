module Mux6(clock, entrada0, entrada1, entrada2, entrada3, entrada4, controle, saida);
	
	//Iniciando os fio tudo.
	input wire clock;
	input wire [4:0]entrada0;
	input wire [4:0]entrada1;
	input wire [15:11]entrada2;
	input wire [4:0]entrada3;
	input wire [4:0]entrada4;
	input wire [2:0]controle;
	output reg [4:0]saida;

	parameter selectEntrada0=3'b000;
	parameter selectEntrada1=3'b001;
	parameter selectEntrada2=3'b010;
	parameter selectEntrada3=3'b011;
	parameter selectEntrada4=3'b100;
	
	//Setando estado inicial para todos os fios.
	initial begin
		saida <= 5'b0000000000000000;
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

			selectEntrada3: begin
				saida <= 5'b11101;
			end
			selectEntrada4: begin
				saida <= 5'b11111;
			end
		endcase
	end
endmodule