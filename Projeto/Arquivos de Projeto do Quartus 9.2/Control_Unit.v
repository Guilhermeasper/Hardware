
module Control_Unit(
	input clock,
	input equal,
	input less,
	input greater,
	input[5:0] opcode,
	input[5:0] funct,
	input div0,
	input overflow,
	input reset,
	input negative,
	input zero,
	output reg pc_write,
	output reg[1:0] mux_1,       //mux_to_mux_mem
	output reg[1:0] mux_2,       //mux_mem
	output reg mux_4,            //shift_source
	output reg mux_3,            //shamt
	output reg[2:0] mux_6,       //regDST
	output reg[3:0] mux_7,       //mem_to_reg
	output reg[1:0] mux_8,       //ALUSourceA
	output reg[2:0] mux_9,       //ALUSourceB
	output reg[2:0] mux_10,      //mux_to_pc
	output reg[1:0] mux_11,      //mux_to_mem_to_reg
	output reg[2:0] shift_control,
	output reg[1:0] ss_control,
	output reg mem_write,
	output reg [1:0] mult_div,
	output reg ir_write,
	output reg hi_lo,
	output reg EPC_CONTROL,
	output reg MDR_CONTROL,
	output reg[1:0] LOAD_SIZE,
	output reg[2:0] ALU_CONTROL,
	output reg ALU_OUT,
	output reg REG_A,
	output reg REG_B,
	output reg REG_WRITE,
	output reg XCH_CONTROL,
	output reg[7:0] state,
	output reg[7:0] next_state

);

reg[7:0] counter;
reg[1:0] stateOverflow;

initial begin
    state = 8'b0;
    stateOverflow = 2'b0;
    counter = 8'd0;
    next_state = 8'b0;
end

always@(posedge clock) begin
	if (reset) begin
		next_state = 8'b00000000;
	end	

	case(next_state)
		8'b00000000: begin // RESET
			pc_write = 1'b0;
			mux_1 = 2'b0;
			mux_2 = 2'b0;
			mux_3 = 1'b0;
			mux_4 = 1'b0;
			mux_6 = 3'b11;
			mux_7 = 4'b111;
			mux_8 = 2'b0;
			mux_9 = 3'b0;
			mux_10 = 3'b0;
			mux_11 = 1'b0;
			shift_control = 3'b0;
			ss_control = 1'b0;
			mem_write = 1'b0;
			mult_div = 2'b0;
			ir_write = 1'b0;
			hi_lo = 1'b0;
			EPC_CONTROL = 1'b0;
			MDR_CONTROL = 1'b0;
			LOAD_SIZE = 2'b0;
			ALU_CONTROL = 3'b0;
			ALU_OUT = 1'b0;
			REG_A = 2'b0;
			REG_B = 2'b0;
			REG_WRITE = 1'b1;
			XCH_CONTROL = 1'b0;
			
			next_state = 8'b00000001;
		end
		8'b00000001: begin // FETCH
			pc_write = 1'b0;
            mux_1 = 2'b0;
            mux_2 = 2'b0;         //escolhe o PC
            mux_3 = 1'b0;
            mux_4 = 1'b0;
            mux_6 = 3'b0;
            mux_7 = 4'b0;
            mux_8 = 2'b0;         //escolhe PC
            mux_9 = 3'b1;         //escolhe 4
            mux_10=3'b0;          //escolhe PC+4
            mux_11 = 1'b0;
            shift_control = 3'b0;
            ss_control = 1'b0;
            mem_write = 1'b0;
            mult_div = 2'b0;
            ir_write = 1'b1;      //escreve a instrucao em ir_write
            hi_lo = 1'b0;
            EPC_CONTROL=1'b0;
            MDR_CONTROL = 1'b0;
            LOAD_SIZE = 2'b0;
            ALU_CONTROL=3'b1;     //faz PC+4
            ALU_OUT=1'b0;
            REG_A=2'b0;
            REG_B=2'b0;
            REG_WRITE = 1'b0;
            XCH_CONTROL = 1'b0;
			
			if(counter == 8'd1) begin //WAIT
				counter = 8'd0;
				next_state = 8'b00000010;
			end
			else begin
				counter = counter + 8'd1;
			end

		end
		8'b00000010: begin // FETCH_2
			pc_write = 1'b1;
            mux_1 = 2'b0;
            mux_2 = 2'b0;         
            mux_3 = 1'b0;
            mux_4 = 1'b0;
            mux_6 = 3'b0;
            mux_7 = 4'b0;
            mux_8 = 2'b0;         
            mux_9 = 3'b1;         
            mux_10= 3'b0;          
            mux_11 = 1'b0;
            shift_control = 3'b0;
            ss_control = 1'b0;
            mem_write = 1'b0;
            mult_div = 2'b0;
            ir_write = 1'b0; // de 1'b0 para 1'b1 
            hi_lo = 1'b0;
            EPC_CONTROL=1'b0;
            MDR_CONTROL = 1'b0;
            LOAD_SIZE = 2'b0;
            ALU_CONTROL=3'b1;
            ALU_OUT=1'b0;
            REG_A=2'b0;
            REG_B=2'b0;
            REG_WRITE = 1'b0;
            XCH_CONTROL = 1'b0;

			next_state = 8'b00000011;
			counter = 8'd0;
		end
		8'b00000011: begin // DECODE
			pc_write=1'b0; //PC agora e PC+4
			mux_2=2'b0;
			mux_1=2'b0;
			mem_write=1'b0;      // --> ERRADO <-- coloca rs e rt no banco de registradores
			ss_control=1'b0;
			mult_div=2'b0;
			hi_lo=1'b0;
			ir_write=1'b0;
			MDR_CONTROL=1'b0;
			LOAD_SIZE=2'b0;
			mux_4=1'b0;
			mux_3=1'b0;
			shift_control=3'b0;
			mux_11=1'b0;
			mux_7=4'b0;
			mux_6=3'b0;
			REG_WRITE=1'b0;
			mux_8=2'b0;                     //escolhe PC
			mux_9=3'b100;             //        //->ERRADO, acho q deveria ser b1000 <-escolhe sinal extendido e shiftado de 15-0
			ALU_CONTROL=3'b1;               //ERRADO, soma � b1 <- faz PC+o escrito acima
			ALU_OUT=1'b1;                   //salva a soma em ALU_OUT
			EPC_CONTROL=1'b0;
			mux_10=3'b0;
			XCH_CONTROL = 1'b1;//load a em xch
			REG_A=2'b1;//load rs em a // ERRADO, � pra ser b1 pra dar write;
			REG_B=2'b1;//load rt em b // ERRADO, � pra ser b1 pra dar write;
			case(opcode) // essa linha tem que estar dentro de um estado tbm
				6'b0: begin // caso formato r
					case(funct)
						6'h20: next_state = 8'b00000100;//ADD
                        6'h24: next_state = 8'b00000101;//AND
                        6'h22: next_state = 8'b00000110;//SUB
                        6'h0: next_state  = 8'b00000111;//SLL
                        6'h2: next_state  = 8'b00000111;//SRL
                        6'h3: next_state  = 8'b00000111;//SRA
                        6'h4: next_state  = 8'b00001010;//SLV
                        6'h7: next_state  = 8'b00001010;//SRAV
                        6'h10: next_state = 8'b00001100;//MFHI
                        6'h12: next_state = 8'b00001101;//MFLO
                        6'h2a: next_state = 8'b00001110;//SLT
                        6'h8: next_state  = 8'b00001111;//JR
                        6'h13: next_state = 8'b00010000;//RTE
                        6'hd: next_state  = 8'b00010001;//BREAK
                        6'h18: next_state = 8'b00010010;//MULT
                        6'h1a: next_state = 8'b00010011;//DIV
						6'h5: next_state =  8'b00010100;//XCH
                    endcase
                end
 
                6'h2: next_state = 8'b00010101;//J
                6'h3: next_state = 8'b00010110;//JAL
                6'h10: next_state = 8'b00000100;
                6'h11: next_state = 8'b00000100;
                6'h8: next_state = 8'b00000100;
                6'h9: next_state = 8'b00000100;
                6'h4: next_state = 8'b00000100;
                6'h5: next_state = 8'b00000100;
                6'h6: next_state = 8'b00000100;
                6'h7: next_state = 8'b00000100;
                6'hf: next_state = 8'b00000100;
                6'ha: next_state = 8'b00000100;
                6'h28: next_state = 8'b00000100;
                6'h29: next_state = 8'b00000100;
                6'h2b: next_state = 8'b00000100;
                6'h20: next_state = 8'b00000100;
                6'h21: next_state = 8'b00000100;
                6'h23: next_state = 8'b00000100;
                default: next_state = 8'b00000101;
            endcase
		end
			
		8'b00000100: begin // ADD_1/2
			pc_write=1'b0;
			mux_1=2'b0;
			mux_2=2'b0;
			mux_3=1'b0;
			mux_4=1'b0;
			mux_6=3'b0;
			mux_7=4'b0;
			mux_8=2'b10;//escolhe A
			mux_9=3'b0;//escolhe B
			mux_10=3'b0;
			mux_11=1'b0;
			shift_control=3'b0;
			ss_control=1'b0;
			mem_write=1'b0;
			mult_div=2'b0;
			ir_write=1'b0;    
			hi_lo=1'b0;
			EPC_CONTROL=1'b0;
			MDR_CONTROL=1'b0;
			LOAD_SIZE=2'b0;
			ALU_CONTROL=3'b1;//soma A + B
			ALU_OUT=1'b1;//salva A+B em ALU_OUT
			REG_A=2'b0;
			REG_B=1'b0;
			REG_WRITE=1'b0;
			XCH_CONTROL = 1'b0;
			next_state = 8'b10000101; // next_state = ADD/AND/SUB_2;
		end
		8'b00000101: begin // AND_1/2
			pc_write=1'b0;
			mux_1=2'b0;
			mux_2=2'b0;
			mux_3=1'b0;
			mux_4=1'b0;
			mux_6=3'b0;
			mux_7=4'b0;
			mux_8=2'b10;//escolhe A
			mux_9=3'b0;//escolhe B
			mux_10=3'b0;
			mux_11=1'b0;
			shift_control=3'b0;
			ss_control=1'b0;
			mem_write=1'b0;
			mult_div=2'b0;
			ir_write=1'b0;    
			hi_lo=1'b0;
			EPC_CONTROL=1'b0;
			MDR_CONTROL=1'b0;
			LOAD_SIZE=2'b0;
			ALU_CONTROL=3'b11;//FAZ A && B
			ALU_OUT=1'b1;//salva A+B em ALU_OUT
			REG_A=2'b0;
			REG_B=1'b0;
			REG_WRITE=1'b0;
			XCH_CONTROL = 1'b0;
			next_state = 8'b10000101; // next_state = ADD/AND/SUB_2;
		end
		8'b00000110: begin // SUB_1/2
			pc_write=1'b0;
			mux_1=2'b0;
			mux_2=2'b0;
			mux_3=1'b0;
			mux_4=1'b0;
			mux_6=3'b0;
			mux_7=4'b0;
			mux_8=2'b10;//escolhe A
			mux_9=3'b0;//escolhe B
			mux_10=3'b0;
			mux_11=1'b0;
			shift_control=3'b0;
			ss_control=1'b0;
			mem_write=1'b0;
			mult_div=2'b0;
			ir_write=1'b0;    
			hi_lo=1'b0;
			EPC_CONTROL=1'b0;
			MDR_CONTROL=1'b0;
			LOAD_SIZE=2'b0;
			ALU_CONTROL=3'b10;//subtrai A - B
			ALU_OUT=1'b1;//salva A+B em ALU_OUT
			REG_A=2'b0;
			REG_B=1'b0;
			REG_WRITE=1'b0;
			XCH_CONTROL = 1'b0;
			next_state = 8'b10000101; // next_state = ADD/AND/SUB_2;
		end
		8'b00010011: begin //DIV
			pc_write=1'b0;
			mux_1=2'b0;
			mux_2=2'b0;
			mux_3=1'b0;
			mux_4=1'b0;
			mux_6=3'b0;
			mux_7=4'b0;
			mux_8=2'b0;//escolhe A
			mux_9=3'b0;//escolhe B
			mux_10=3'b0;
			mux_11=1'b0;
			shift_control=3'b0;
			ss_control=1'b0;
			mem_write=1'b0;
			mult_div=2'b10;
			ir_write=1'b0;    
			hi_lo=1'b0;
			EPC_CONTROL=1'b0;
			MDR_CONTROL=1'b0;
			LOAD_SIZE=2'b0;
			ALU_CONTROL=3'b0;//subtrai A - B
			ALU_OUT=1'b0;//salva A+B em ALU_OUT
			REG_A=2'b0;
			REG_B=1'b0;
			REG_WRITE=1'b0;
			XCH_CONTROL = 1'b0;
			counter = 8'b0;
			next_state = 8'b00011101; // next_state = DIV/MULT WAIT;
			end
		8'b00010010: begin //MULT
			pc_write=1'b0;
			mux_1=2'b0;
			mux_2=2'b0;
			mux_3=1'b0;
			mux_4=1'b0;
			mux_6=3'b0;
			mux_7=4'b0;
			mux_8=2'b0;//escolhe A
			mux_9=3'b0;//escolhe B
			mux_10=3'b0;
			mux_11=1'b0;
			shift_control=3'b0;
			ss_control=1'b0;
			mem_write=1'b0;
			mult_div=2'b1;
			ir_write=1'b0;
			hi_lo=1'b0;
			EPC_CONTROL=1'b0;
			MDR_CONTROL=1'b0;
			LOAD_SIZE=2'b0;
			ALU_CONTROL=3'b0;//subtrai A - B
			ALU_OUT=1'b0;//salva A+B em ALU_OUT
			REG_A=2'b0;
			REG_B=1'b0;
			REG_WRITE=1'b0;
			XCH_CONTROL = 1'b0;
			counter = 8'b0;
			next_state = 8'b00011101; // next_state = DIV/MULT WAIT;
			end
		8'b00001100: begin // MFHI
			pc_write=1'b0;
			mux_1=2'b0;
			mux_2=2'b0;
			mux_3=1'b0;
			mux_4=1'b0;
			mux_6=3'b10;//escolhe rd
			mux_7=4'b10;// escolhe o que est� em HI
			mux_8=2'b0;
			mux_9=3'b0;
			mux_10=3'b0;
			mux_11=1'b0;
			shift_control=3'b0;
			ss_control=1'b0;
			mem_write=1'b0;
			mult_div=2'b0;
			ir_write=1'b0;    
			hi_lo=1'b1;
			EPC_CONTROL=1'b0;
			MDR_CONTROL=1'b0;
			LOAD_SIZE=2'b0;
			ALU_CONTROL=3'b0;
			ALU_OUT=1'b0;
			REG_A=2'b0;
			REG_B=1'b0;
			REG_WRITE=1'b1;//permite escrever no banco de regs
			XCH_CONTROL = 1'b0;
			next_state = 8'b11111111; //passa pra final
		end
		8'b00001101: begin // MFLO
			pc_write=1'b0;
			mux_1=2'b0;
			mux_2=2'b0;
			mux_3=1'b0;
			mux_4=1'b0;
			mux_6=3'b10;//escolhe rd
			mux_7=4'b11;// escolhe o que est� em LO
			mux_8=2'b0;
			mux_9=3'b0;
			mux_10=3'b0;
			mux_11=1'b0;
			shift_control=3'b0;
			ss_control=1'b0;
			mem_write=1'b0;
			mult_div=2'b0;
			ir_write=1'b0;    
			hi_lo=1'b1;
			EPC_CONTROL=1'b0;
			MDR_CONTROL=1'b0;
			LOAD_SIZE=2'b0;
			ALU_CONTROL=3'b0;
			ALU_OUT=1'b0;
			REG_A=2'b0;
			REG_B=1'b0;
			REG_WRITE=1'b1;//permite escrever no banco de regs
			XCH_CONTROL = 1'b0;
			next_state = 8'b11111111; //passa pra final
		end
		8'b00010000: begin //RTE
			pc_write=1'b1;//abilita para escrita no pr�ximo ciclo
			mux_1=2'b0;
			mux_2=2'b0;
			mux_3=1'b0;
			mux_4=1'b0;
			mux_6=3'b0;
			mux_7=4'b0;
			mux_8=2'b0;
			mux_9=3'b0;
			mux_10=3'b10;// escolhe EPC para salvar em PC
			mux_11=1'b0;
			shift_control=3'b0;
			ss_control=1'b0;
			mem_write=1'b0;
			mult_div=2'b0;
			ir_write=1'b0;    
			hi_lo=1'b0;
			EPC_CONTROL=1'b0;
			MDR_CONTROL=1'b0;
			LOAD_SIZE=2'b0;
			ALU_CONTROL=3'b0;
			ALU_OUT=1'b0;
			REG_A=2'b0;
			REG_B=1'b0;
			REG_WRITE=1'b0;
			XCH_CONTROL = 1'b0;
			next_state = 8'b11111111;//passa pra final
		end
		8'b00010001: begin //BREAK
			pc_write=1'b1;//abilita para escrita no pr�ximo ciclo
			mux_1=2'b0;
			mux_2=2'b0;
			mux_3=1'b0;
			mux_4=1'b0;
			mux_6=3'b0;
			mux_7=4'b0;
			mux_8=2'b0;//escolhe PC
			mux_9=3'b1;// escolhe 4
			mux_10=3'b0;// escolhe PC-4 para salvar em PC
			mux_11=1'b0;
			shift_control=3'b0;
			ss_control=1'b0;
			mem_write=1'b0;
			mult_div=2'b0;
			ir_write=1'b0;    
			hi_lo=1'b0;
			EPC_CONTROL=1'b0;
			MDR_CONTROL=1'b0;
			LOAD_SIZE=2'b0;
			ALU_CONTROL=3'b10;//escolhe subtra��o
			ALU_OUT=1'b0;
			REG_A=2'b0;
			REG_B=1'b0;
			REG_WRITE=1'b0;
			XCH_CONTROL = 1'b0;
			next_state = 8'b11111111;//passa pra final
		end
		8'b00001110: begin // SLT
			pc_write=1'b0;
			mux_1=2'b0;
			mux_2=2'b0;
			mux_3=1'b0;
			mux_4=1'b0;
			mux_6=3'b10;///escolhe rd
			mux_7=4'b1001;//escolhe o sinal estendido de LT
			mux_8=2'b10;//escolhe a
			mux_9=3'b0;//escolhe b
			mux_10=3'b0;
			mux_11=1'b0;
			shift_control=3'b0;
			ss_control=1'b0;
			mem_write=1'b0;
			mult_div=2'b0;
			ir_write=1'b0;    
			hi_lo=1'b0;
			EPC_CONTROL=1'b0;
			MDR_CONTROL=1'b0;
			LOAD_SIZE=2'b0;
			ALU_CONTROL=3'b111;//escolhe compara��o
			ALU_OUT=1'b0;
			REG_A=2'b0;
			REG_B=1'b0;
			REG_WRITE=1'b1;// habilita escrita no banco de regs
			XCH_CONTROL = 1'b0;
			next_state = 8'b11111111;//passa pra final
		end
		8'b00001111: begin // JR
			pc_write=1'b1;//habilita para escrita no próximo ciclo
			mux_1=2'b0;
			mux_2=2'b0;
			mux_3=1'b0;
			mux_4=1'b0;
			mux_6=3'b0;
			mux_7=4'b0;
			mux_8=2'b10;// escolhe rs
			mux_9=3'b0;
			mux_10=3'b0;
			mux_11=1'b0;
			shift_control=1'b0;
			ss_control=1'b0;
			mem_write=1'b0;
			mult_div=2'b0;
			ir_write=1'b0;
			hi_lo=1'b0;
			EPC_CONTROL=1'b0;
			MDR_CONTROL=1'b0;
			LOAD_SIZE=2'b0;
			ALU_CONTROL=3'b0;//LOAD
			ALU_OUT=1'b0;
			REG_A=2'b0;
			REG_B=1'b0;
			REG_WRITE=1'b0;
			XCH_CONTROL = 1'b0;
			next_state = 8'b11111111;// passa pro final
		end
		8'b00010101: begin //J
			pc_write=1'b1;//habilita escrita em pc no próximo ciclo 
			mux_1=2'b0;
			mux_2=2'b0;
			mux_3=1'b0;
			mux_4=1'b0;
			mux_6=3'b0;
			mux_7=4'b0;
			mux_8=2'b0;
			mux_9=3'b0;
			mux_10=3'b11;//escolhe pc+offset
			mux_11=1'b0;
			shift_control=3'b0;
			ss_control=1'b0;
			mem_write=1'b0;
			mult_div=2'b0;
			ir_write=1'b0;    
			hi_lo=1'b0;
			EPC_CONTROL=1'b0;
			MDR_CONTROL=1'b0;
			LOAD_SIZE=2'b0;
			ALU_CONTROL=3'b0;
			ALU_OUT=1'b0;
			REG_A=2'b0;
			REG_B=1'b0;
			REG_WRITE=1'b0;
			XCH_CONTROL = 1'b0;
			next_state = 8'b11111111;//passa pro final
		end
		8'b00010110: begin//JAL_1/2
			pc_write=1'b0; 
			mux_1=2'b0;
			mux_2=2'b0;
			mux_3=1'b0;
			mux_4=1'b0;
			mux_6=3'b100;//escolhe o r31
			mux_7=4'b0;// escolhe ALU_OUT
			mux_8=2'b0;//escolhe PC
			mux_9=3'b0;
			mux_10=3'b0;
			mux_11=1'b0;
			shift_control=3'b0;
			ss_control=1'b0;
			mem_write=1'b0;
			mult_div=2'b0;
			ir_write=1'b0;    
			hi_lo=1'b0;
			EPC_CONTROL=1'b0;
			MDR_CONTROL=1'b0;
			LOAD_SIZE=2'b0;
			ALU_CONTROL=3'b0;//dá load PC
			ALU_OUT=1'b1;//escreve PC em ALU_OUT
			REG_A=2'b0;
			REG_B=1'b0;
			REG_WRITE=1'b1;//habilita para escrita no próximo ciclo
			XCH_CONTROL = 1'b0;
			next_state = 8'b10001000;//passa pro segundo passo
		end
		8'b10001000: begin //JAL_2
			pc_write=1'b1;//habilita escrita em pc no próximo ciclo 
			mux_1=2'b0;
			mux_2=2'b0;
			mux_3=1'b0;
			mux_4=1'b0;
			mux_6=3'b0;
			mux_7=4'b0;
			mux_8=2'b0;
			mux_9=3'b0;
			mux_10=3'b11;//escolhe pc+offset
			mux_11=1'b0;
			shift_control=3'b0;
			ss_control=1'b0;
			mem_write=1'b0;
			mult_div=2'b0;
			ir_write=1'b0;    
			hi_lo=1'b0;
			EPC_CONTROL=1'b0;
			MDR_CONTROL=1'b0;
			LOAD_SIZE=2'b0;
			ALU_CONTROL=3'b0;
			ALU_OUT=1'b0;
			REG_A=2'b0;
			REG_B=1'b0;
			REG_WRITE=1'b0;
			XCH_CONTROL = 1'b0;
			next_state = 8'b11111111;//passa pro final
		end
		8'b00010101: begin //J
			pc_write=1'b1;//habilita escrita em pc no próximo ciclo 
			mux_1=2'b0;
			mux_2=2'b0;
			mux_3=1'b0;
			mux_4=1'b0;
			mux_6=3'b0;
			mux_7=4'b0;
			mux_8=2'b0;
			mux_9=3'b0;
			mux_10=3'b11;//escolhe pc+offset
			mux_11=1'b0;
			shift_control=3'b0;
			ss_control=1'b0;
			mem_write=1'b0;
			mult_div=2'b0;
			ir_write=1'b0;    
			hi_lo=1'b0;
			EPC_CONTROL=1'b0;
			MDR_CONTROL=1'b0;
			LOAD_SIZE=2'b0;
			ALU_CONTROL=3'b0;
			ALU_OUT=1'b0;
			REG_A=2'b0;
			REG_B=1'b0;
			REG_WRITE=1'b0;
			XCH_CONTROL = 1'b0;
			next_state = 8'b11111111;//passa pro final
		end
		8'b00010110: begin//JAL_1/2
			pc_write=1'b0; 
			mux_1=2'b0;
			mux_2=2'b0;
			mux_3=1'b0;
			mux_4=1'b0;
			mux_6=3'b100;//escolhe o r31
			mux_7=4'b0;// escolhe ALU_OUT
			mux_8=2'b0;//escolhe PC
			mux_9=3'b0;
			mux_10=3'b0;
			mux_11=1'b0;
			shift_control=3'b0;
			ss_control=1'b0;
			mem_write=1'b0;
			mult_div=2'b0;
			ir_write=1'b0;    
			hi_lo=1'b0;
			EPC_CONTROL=1'b0;
			MDR_CONTROL=1'b0;
			LOAD_SIZE=2'b0;
			ALU_CONTROL=3'b0;//dá load PC
			ALU_OUT=1'b1;//escreve PC em ALU_OUT
			REG_A=2'b0;
			REG_B=1'b0;
			REG_WRITE=1'b1;//habilita para escrita no próximo ciclo
			XCH_CONTROL = 1'b0;
			next_state = 8'b10001000;//passa pro segundo passo
		end
		8'b10001000: begin //JAL_2
			pc_write=1'b1;//habilita escrita em pc no próximo ciclo 
			mux_1=2'b0;
			mux_2=2'b0;
			mux_3=1'b0;
			mux_4=1'b0;
			mux_6=3'b0;
			mux_7=4'b0;
			mux_8=2'b0;
			mux_9=3'b0;
			mux_10=3'b11;//escolhe pc+offset
			mux_11=1'b0;
			shift_control=3'b0;
			ss_control=1'b0;
			mem_write=1'b0;
			mult_div=2'b0;
			ir_write=1'b0;    
			hi_lo=1'b0;
			EPC_CONTROL=1'b0;
			MDR_CONTROL=1'b0;
			LOAD_SIZE=2'b0;
			ALU_CONTROL=3'b0;
			ALU_OUT=1'b0;
			REG_A=2'b0;
			REG_B=1'b0;
			REG_WRITE=1'b0;
			XCH_CONTROL = 1'b0;
			next_state = 8'b11111111;//passa pro final
		end
		8'b00010100: begin //XCH_1/2
			pc_write=1'b0;
			mux_1=2'b0;
			mux_2=2'b0;
			mux_3=1'b0;
			mux_4=1'b0;
			mux_6=3'b1;///escolhe rs
			mux_7=4'b1010;//escolhe rt
			mux_8=2'b0;
			mux_9=3'b0;
			mux_10=3'b0;
			mux_11=1'b0;
			shift_control=3'b0;
			ss_control=1'b0;
			mem_write=1'b0;
			mult_div=2'b0;
			ir_write=1'b0;    
			hi_lo=1'b0;
			EPC_CONTROL=1'b0;
			MDR_CONTROL=1'b0;
			LOAD_SIZE=2'b0;
			ALU_CONTROL=3'b0;
			ALU_OUT=1'b0;
			REG_A=2'b0;
			REG_B=1'b0;
			REG_WRITE=1'b1;// habilita escrita no banco de regs
			XCH_CONTROL = 1'b0;
			next_state = 8'b00010101;//passa pro segundo passo
		end
		8'b00010101: begin //XCH_2
			pc_write=1'b0;
			mux_1=2'b0;
			mux_2=2'b0;
			mux_3=1'b0;
			mux_4=1'b0;
			mux_6=3'b0;///escolhe rt
			mux_7=4'b1000;//escolhe xch
			mux_8=2'b0;
			mux_9=3'b0;
			mux_10=3'b0;
			mux_11=1'b0;
			shift_control=3'b0;
			ss_control=1'b0;
			mem_write=1'b0;
			mult_div=2'b0;
			ir_write=1'b0;    
			hi_lo=1'b0;
			EPC_CONTROL=1'b0;
			MDR_CONTROL=1'b0;
			LOAD_SIZE=2'b0;
			ALU_CONTROL=3'b0;
			ALU_OUT=1'b0;
			REG_A=2'b0;
			REG_B=1'b0;
			REG_WRITE=1'b1;// habilita escrita no banco de regs
			XCH_CONTROL = 1'b0;
			next_state = 8'b11111111;//passa pro final
		end
		8'b00000111: begin //SLL/SRL/SRA_1/3
			pc_write=1'b0;
			mux_1=2'b0;
			mux_2=2'b0;
			mux_3=1'b0;//escolhe rt
			mux_4=1'b0;//escolhe shamt
			mux_6=3'b0;
			mux_7=4'b0;
			mux_8=2'b0;
			mux_9=3'b0;
			mux_10=3'b0;
			mux_11=1'b0;
			shift_control=3'b01;//primeiro d� load no reg
			ss_control=1'b0;
			mem_write=1'b0;
			mult_div=2'b0;
			ir_write=1'b0;    
			hi_lo=1'b0;
			EPC_CONTROL=1'b0;
			MDR_CONTROL=1'b0;
			LOAD_SIZE=2'b0;
			ALU_CONTROL=3'b0;
			ALU_OUT=1'b0;
			REG_A=2'b0;
			REG_B=1'b0;
			REG_WRITE=1'b0;
			XCH_CONTROL = 1'b0;
			next_state = 8'b10000110;//passa pro segundo passo
		end
		8'b00001010: begin //SLV/SRAV_1/3
			pc_write=1'b0;
			mux_1=2'b0;
			mux_2=2'b0;
			mux_3=1'b1;//escolhe rs
			mux_4=1'b1;//escolhe rt
			mux_6=3'b0;
			mux_7=4'b0;
			mux_8=2'b0;
			mux_9=3'b0;
			mux_10=3'b0;
			mux_11=1'b0;
			shift_control=3'b01;//primeiro d� load no reg
			ss_control=1'b0;
			mem_write=1'b0;
			mult_div=2'b0;
			ir_write=1'b0;    
			hi_lo=1'b0;
			EPC_CONTROL=1'b0;
			MDR_CONTROL=1'b0;
			LOAD_SIZE=2'b0;
			ALU_CONTROL=3'b0;
			ALU_OUT=1'b0;
			REG_A=2'b0;
			REG_B=1'b0;
			REG_WRITE=1'b0;
			XCH_CONTROL = 1'b0;
			next_state = 8'b10000110;//passa pro segundo passo
		end
		8'b10000101: begin // WRITE_ARIT
			pc_write=1'b0;
			mux_1=2'b0;
			mux_2=2'b0;
			mux_3=1'b0;
			mux_4=1'b0;
			mux_6=3'b10;//escolhe rd
			mux_7=4'b0;// escolhe o que est� em ALU_OUT
			mux_8=2'b0;
			mux_9=3'b0;
			mux_10=3'b0;
			mux_11=1'b0;
			shift_control=3'b0;
			ss_control=1'b0;
			mem_write=1'b0;
			mult_div=2'b0;
			ir_write=1'b0;    
			hi_lo=1'b0;
			EPC_CONTROL=1'b0;
			MDR_CONTROL=1'b0;
			LOAD_SIZE=2'b0;
			ALU_CONTROL=3'b0;
			ALU_OUT=1'b0;
			REG_A=2'b0;
			REG_B=1'b0;
			REG_WRITE=1'b1;//permite escrever no banco de regs
			XCH_CONTROL = 1'b0;
			next_state = 8'b11111111;
		end
		8'b10000110: begin // SLL/SLLV/SRA/SRAV/SRL_2/3
			case(funct) 
				6'h0: begin //SLL_2/3
					pc_write=1'b0;
					mux_1=2'b0;
					mux_2=2'b0;
					mux_3=1'b0;//escolhe rt
					mux_4=1'b0;//escolhe shamt
					mux_6=3'b0;
					mux_7=4'b0;
					mux_8=2'b0;
					mux_9=3'b0;
					mux_10=3'b0;
					mux_11=1'b0;
					shift_control=3'b10;//escolhe shift_left
					ss_control=1'b0;
					mem_write=1'b0;
					mult_div=2'b0;
					ir_write=1'b0;    
					hi_lo=1'b0;
					EPC_CONTROL=1'b0;
					MDR_CONTROL=1'b0;
					LOAD_SIZE=2'b0;
					ALU_CONTROL=3'b0;
					ALU_OUT=1'b0;
					REG_A=2'b0;
					REG_B=1'b0;
					REG_WRITE=1'b0;
					XCH_CONTROL = 1'b0;
					next_state = 8'b10000111;
				end
				6'h4: begin //SLV_2/3
					pc_write=1'b0;
					mux_1=2'b0;
					mux_2=2'b0;
					mux_3=1'b1;//escolhe rs
					mux_4=1'b1;//escolhe rt
					mux_6=3'b0;
					mux_7=4'b0;
					mux_8=2'b0;
					mux_9=3'b0;
					mux_10=3'b0;
					mux_11=1'b0;
					shift_control=3'b10;//escolhe shift_left
					ss_control=1'b0;
					mem_write=1'b0;
					mult_div=2'b0;
					ir_write=1'b0;    
					hi_lo=1'b0;
					EPC_CONTROL=1'b0;
					MDR_CONTROL=1'b0;
					LOAD_SIZE=2'b0;
					ALU_CONTROL=3'b0;
					ALU_OUT=1'b0;
					REG_A=2'b0;
					REG_B=1'b0;
					REG_WRITE=1'b0;
					XCH_CONTROL = 1'b0;
					next_state = 8'b10000111;
				end
				6'h3: begin //SRA_2/3
					pc_write=1'b0;
					mux_1=2'b0;
					mux_2=2'b0;
					mux_3=1'b0;//escolhe rt
					mux_4=1'b0;//escolhe shamt
					mux_6=3'b0;
					mux_7=4'b0;
					mux_8=2'b0;
					mux_9=3'b0;
					mux_10=3'b0;
					mux_11=1'b0;
					shift_control=3'b100;//escolhe shift_right aritm�tico
					ss_control=1'b0;
					mem_write=1'b0;
					mult_div=2'b0;
					ir_write=1'b0;    
					hi_lo=1'b0;
					EPC_CONTROL=1'b0;
					MDR_CONTROL=1'b0;
					LOAD_SIZE=2'b0;
					ALU_CONTROL=3'b0;
					ALU_OUT=1'b0;
					REG_A=2'b0;
					REG_B=1'b0;
					REG_WRITE=1'b0;
					XCH_CONTROL = 1'b0;
					next_state = 8'b10000111;
				end
				6'h7: begin //SRAV_2/3
					pc_write=1'b0;
					mux_1=2'b0;
					mux_2=2'b0;
					mux_3=1'b1;//escolhe rs
					mux_4=1'b1;//escolhe rt
					mux_6=3'b0;
					mux_7=4'b0;
					mux_8=2'b0;
					mux_9=3'b0;
					mux_10=3'b0;
					mux_11=1'b0;
					shift_control=3'b100;//escolhe shift_right aritm�tico
					ss_control=1'b0;
					mem_write=1'b0;
					mult_div=2'b0;
					ir_write=1'b0;    
					hi_lo=1'b0;
					EPC_CONTROL=1'b0;
					MDR_CONTROL=1'b0;
					LOAD_SIZE=2'b0;
					ALU_CONTROL=3'b0;
					ALU_OUT=1'b0;
					REG_A=2'b0;
					REG_B=1'b0;
					REG_WRITE=1'b0;
					XCH_CONTROL = 1'b0;
					next_state = 8'b10000111;
				end
				6'h2: begin //SRL_2/3
					pc_write=1'b0;
					mux_1=2'b0;
					mux_2=2'b0;
					mux_3=1'b0;//escolhe rt
					mux_4=1'b0;//escolhe shamt
					mux_6=3'b0;
					mux_7=4'b0;
					mux_8=2'b0;
					mux_9=3'b0;
					mux_10=3'b0;
					mux_11=1'b0;
					shift_control=3'b11;//escolhe shift_right l�gico
					ss_control=1'b0;
					mem_write=1'b0;
					mult_div=2'b0;
					ir_write=1'b0;    
					hi_lo=1'b0;
					EPC_CONTROL=1'b0;
					MDR_CONTROL=1'b0;
					LOAD_SIZE=2'b0;
					ALU_CONTROL=3'b0;
					ALU_OUT=1'b0;
					REG_A=2'b0;
					REG_B=1'b0;
					REG_WRITE=1'b0;
					XCH_CONTROL = 1'b0;
					next_state = 8'b10000111;
				end
			endcase
		end
		8'b10000111: begin // SLL/SLLV/SRA/SRAV/SRL_3
			pc_write=1'b0;
			mux_1=2'b0;
			mux_2=2'b0;
			mux_3=1'b0;
			mux_4=1'b0;
			mux_6=3'b10;//escolhe rd
			mux_7=4'b110;//escolhe a sa�da do shift_reg
			mux_8=2'b0;
			mux_9=3'b0;
			mux_10=3'b0;
			mux_11=1'b0;
			shift_control=3'b0;
			ss_control=1'b0;
			mem_write=1'b0;
			mult_div=2'b0;
			ir_write=1'b0;    
			hi_lo=1'b0;
			EPC_CONTROL=1'b0;
			MDR_CONTROL=1'b0;
			LOAD_SIZE=2'b0;
			ALU_CONTROL=3'b0;
			ALU_OUT=1'b0;
			REG_A=2'b0;
			REG_B=1'b0;
			REG_WRITE=1'b1;//habilita a escrita no banco de regs
			XCH_CONTROL = 1'b0;
			next_state = 8'b11111111;//passa pro final
		end
		8'b00011101: begin //DIV/MULT WAIT
			pc_write=1'b0;
			mux_1=2'b0;
			mux_2=2'b0;
			mux_3=1'b0;
			mux_4=1'b0;
			mux_6=3'b0;
			mux_7=4'b0;
			mux_8=2'b0;
			mux_9=3'b0;
			mux_10=3'b0;
			mux_11=1'b0;
			shift_control=3'b0;
			ss_control=1'b0;
			mult_div=2'b0;
			ir_write=1'b0;    
			EPC_CONTROL=1'b0;
			MDR_CONTROL=1'b0;
			LOAD_SIZE=2'b0;
			ALU_CONTROL=3'b0;
			ALU_OUT=1'b0;
			REG_A=2'b0;
			REG_B=1'b0;
			REG_WRITE=1'b0;
			XCH_CONTROL = 1'b0;
			next_state = 8'b00011101;
			if(counter == 8'd33) begin //WAIT
				hi_lo=1'b1;
				counter = 8'd0;
				mem_write=1'b0;
				next_state = 8'b11111111;
			end
			else begin
				counter = counter + 8'd1;
				hi_lo=1'b0;
			end
		end
		8'b11111111: begin // FINAL
			pc_write=1'b0;
			mux_1=2'b0;
			mux_2=2'b0;
			mux_3=1'b0;
			mux_4=1'b0;
			mux_6=3'b0;
			mux_7=4'b0;
			mux_8=2'b0;
			mux_9=3'b0;
			mux_10=3'b0;
			mux_11=1'b0;
			shift_control=3'b0;
			ss_control=1'b0;
			mem_write=1'b0;
			mult_div=2'b0;
			ir_write=1'b0;    
			hi_lo=1'b0;
			EPC_CONTROL=1'b0;
			MDR_CONTROL=1'b0;
			LOAD_SIZE=2'b0;
			ALU_CONTROL=3'b0;
			ALU_OUT=1'b0;
			REG_A=2'b0;
			REG_B=1'b0;
			REG_WRITE=1'b0;
			XCH_CONTROL = 1'b0;
			next_state = 8'b00000001;//passa pra fetch
		end
    endcase
	
end
endmodule