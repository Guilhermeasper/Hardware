module mux2(clock, entrada0, entrada1, entrada2, entrada 3, controle, saida);
	
	//Iniciando os fio tudo.
	input wire clock;
	input wire entrada0[15:0];
	input wire entrada1[15:0];
	input wire entrada2[15:0];
	input wire entrada3[15:0];
	input wire controle[?:0];
	output reg saida[15:0];

	parameter selectEntrada0=16'b0000000000000000;
	parameter selectEntrada1=16'b0000000000000001;
	parameter selectEntrada2=16'b0000000000000010;
	parameter selectEntrada3=16'b0000000000000011;
	
	//Setando estado inicial para todos os fios.
	initial begin
		controle = 16'b0000000000000000;
		saida = 16'b0000000000000000;
		entrada0 = 16'b0000000000000000;
		entrada1 = 16'b0000000000000000;
		entrada2 = 16'b0000000000000000;
		entrada3 = 16'b0000000000000000;
	end

	always@(*) begin
		case (controle)
			selectEntrada0: begin
				saida = entrada0;
			end

			selectEntrada1: begin
				saida = entrada1;
			end

			selectEntrada2: begin
				saida = entrada2;
			end

			selectEntrada3: begin
				saida = entrada3;
			end
	end
	
endmodule