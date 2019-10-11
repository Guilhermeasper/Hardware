module mux10(clock, entrada0, entrada1, entrada2, entrada3, entrada4, controle, saida);
	
	//Iniciando os fio tudo.
	input wire clock;
	input wire [31:0]entrada0;
	input wire [31:0]entrada1;
	input wire [31:0]entrada2;
	input wire [31:0]entrada3;
	input wire [31:0]entrada4;
	input wire [2:0]controle;
	output reg [31:0]saida;

	parameter selectEntrada0=3'b000;
	parameter selectEntrada1=3'b001;
	parameter selectEntrada2=3'b010;
	parameter selectEntrada3=3'b011;
	parameter selectEntrada4=3'b100;
	
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

			selectEntrada3: begin
				saida <= entrada3;
			end
			selectEntrada4: begin
				saida <= entrada4;
			end
		endcase
	end
endmodule