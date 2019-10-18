 module Mux7(clock, entrada0, entrada1, entrada2, entrada3, entrada4, entrada5, entrada6, entrada7, entrada8, entrada9, entrada10, controle, saida);
	
	//Iniciando os fio tudo.
	input wire clock;
	input wire [31:0]entrada0;
	input wire [31:0]entrada1;
	input wire [31:0]entrada2;
	input wire [31:0]entrada3;
	input wire [31:0]entrada4;
	input wire [31:0]entrada5;
	input wire [31:0]entrada6;
	input wire [31:0]entrada7;
	input wire [31:0]entrada8;
	input wire [31:0]entrada9;
	input wire [31:0]entrada10;
	input wire [3:0]controle;
	output reg [31:0]saida;
	
	//Setando estado inicial para todos os fios.
	initial begin
		saida <= 32'b0000000000000000;
	end

	always@(*) begin
		case (controle)
			4'b0000: begin
				saida <= entrada0;
			end

			4'b0001: begin
				saida <= entrada1;
			end

			4'b0010: begin
				saida <= entrada2;
			end

			4'b0011: begin
				saida <= entrada3;
			end
			
			4'b0100: begin
				saida <= entrada4;
			end
			
			4'b0101: begin
				saida <= entrada5;
			end
			
			4'b0110: begin
				saida <= entrada6;
			end
			
			4'b0111: begin
				saida <= 32'd227;
			end
			
			4'b1000: begin
				saida <= entrada8;
			end
			
			4'b1001: begin
				saida <= entrada9;
			end
			
			4'b1010: begin
				saida <= entrada10;
			end
			
		endcase
	end
endmodule