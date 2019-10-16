module mux11(clock, entrada0, entrada1, controle, saida);
	
	//Iniciando os fio tudo.
	input wire clock;
	input wire [31:0]entrada0;
	input wire [31:0]entrada1;
	input wire controle;
	output reg [31:0]saida;

	parameter selectEntrada0=1'b0;
	parameter selectEntrada1=1'b1;
	
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
		endcase
	end
endmodule