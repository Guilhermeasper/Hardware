module sinal(clock, botao, verde, amarelo, vermelho);
	
	// Iniciando os fio tudo
	input wire botao;
	input wire clock;
	output reg verde;
	output reg amarelo;
	output reg vermelho;
	
	// Setando contagem, que tem que ter 5 bits pra chegar até 30
	reg[4:0] contagem;
	// Setando estado, que tem que ter 2 bits, pq são 4 estados
	reg[1:0] estado;
	
	// Definindo cada estado
	
	// VD é VerDe
	parameter VD=2'b00;
	// AM é AMarelo
	parameter AM=2'b01;
	// VM é VerMelho
	parameter VM=2'b10;
	// VB é VerdeBotao
	parameter VB=2'b11;
	
	// É tipo o reset
	initial begin
		// Estado inicial tá verde, mas não tá verde de verdade(não conta até o primeiro clock)
		estado = 2'b00;
		verde = 1'b0;
		amarelo = 1'b0;
		vermelho = 1'b0;
		contagem = 5'b00000;
	end
	
	always@(posedge clock) begin
		// Um switch case normal
		case(estado)
			
			// Se estiver no verde(se o estado for = 00)
			VD: begin
				/* Seta o estado vermelho como 0(notar que não precisamos setar o amarelo também, porque
				ele nunca vai do amarelo pro verde) */
				vermelho = 1'b0;
				// Como tá no estado verde, a gente bota o flag do verde como 1
				verde = 1'b1;
				// Se apertar o botão nesse estado
				if(botao == 1) begin
					// A contagem vai multiplicar por 2
					contagem = contagem + ((19 - contagem)/2);
					// E aí vamos pro estado do botão verde pressionado
					estado = VB;
				end
				else begin
					// Se a contagem estiver em 19:
					if(contagem == 5'b10011) begin
					    // Vamos para o estado amarelo, e resetamos a contagem.
						estado = AM;
						contagem = 5'b00000;
					end
					// Senão, só soma um na contagem mesmo.
					else begin
						estado = VD;
						contagem = contagem + 1;
					end
				end
			end
			
			// Caso estivermos no estado do verde com o botão tendo sido pressionado
			VB: begin
				// Setando vermelho para 0, caso o botão tenha sido apertado no começo do verde
				vermelho = 1'b0;
				// Setando verde para 1 pelo mesmo motivo
				verde = 1'b1;
				// Se a contagem for 19, a gente vai pro amarelo (mesma ideia dali de cima)
				if(contagem == 5'b10011) begin
					estado = AM;
					contagem = 5'b00000;
				end
				else begin
					estado = VD;
					contagem = contagem + 1;
				end
			end
			
			// Para o estado amarelo, a única diferença é que ele muda de estado em 9, não em 19
			AM: begin
				// Setamos o verde para 0, caso seja a primeira rodada do amarelo...
				/* (Mais uma vez notar que não mexemos no vermelho, pois ele sempre chegará no amarelo
				a partir do verde. */
				verde = 1'b0;
				// E o amarelo pra 1
				amarelo = 1'b1;
				// Se a contagem estiver em 9:
				if(contagem == 5'b01001) begin
					// Vamos para o estado vermelho, e resetamos a contagem.
					estado = VM;
					contagem = 5'b00000;
				end
				else begin
					// Senão, só soma um na contagem e reafirma o estado amarelo.
					estado = AM;
					contagem = contagem + 1;
				end
			end
			
			// Estado vermelho
			VM:  begin
			    // Setando o verde pra 0, pois ele sempre chega no vermelho pelo verde...
				verde = 1'b0;
				// E o vermelho pra 1
				vermelho = 1'b1;
				// Se a contagem tiver em 29...
				if(contagem == 5'b11101) begin
					// Vamos para o estado verde, e resetamos a contagem
					estado = VD;
					contagem = 5'b00000;
				end
				// Senão, apenas reafirmamos o estado vermelho, e somamos 1 na contagem.
				else begin
					estado = VM;
					contagem = contagem + 1;
				end
			end
			
		endcase
		
	end
	
endmodule

