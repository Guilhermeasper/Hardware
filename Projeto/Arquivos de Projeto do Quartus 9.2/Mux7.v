 module mux7(clock, entrada0, entrada1, entrada2, entrada3, entrada4, entrada5, entrada6, entrada7, entrada8, entrada9, entrada10, controle, saida);
	
	//Iniciando os fio tudo.
	input wire clock;
	input wire [15:0]entrada0;
	input wire [15:0]entrada1;
	input wire [15:0]entrada2;
	input wire [15:0]entrada3;
	input wire [15:0]entrada4;
	input wire [15:0]entrada5;
	input wire [15:0]entrada6;
	input wire [15:0]entrada7;
	input wire [15:0]entrada8;
	input wire [15:0]entrada9;
	input wire [15:0]entrada10;
	input wire [3:0]controle;
	output reg [15:0]saida;

	parameter selectEntrada0=4'b0000;
	parameter selectEntrada1=4'b0001;
	parameter selectEntrada2=4'b0010;
	parameter selectEntrada3=4'b0011;
	parameter selectEntrada4=4'b0100;
	parameter selectEntrada5=4'b0101;
	parameter selectEntrada6=4'b0110;
	parameter selectEntrada7=4'b0111;
	parameter selectEntrada8=4'b1000;
	parameter selectEntrada9=4'b1001;
	parameter selectEntrada10=4'b1010;
	
	//Setando estado inicial para todos os fios.
	initial begin
		saida <= 16'b0000000000000000;
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
				saida <= entrada3;
			end
			selectEntrada4: begin
				saida <= entrada4;
			end
			selectEntrada5: begin
				saida <= entrada5;
			end
			selectEntrada6: begin
				saida <= entrada6;
			end
			selectEntrada7: begin
				saida <= entrada7;
			end
			selectEntrada8: begin
				saida <= entrada8;
			end
			selectEntrada9: begin
				saida <= entrada9;
			end
			selectEntrada10: begin
				saida <= entrada10;
			end
		endcase
	end
endmodule