
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
	output reg pc_write,
	output reg[1:0] mux_1,       //mux_to_mux_mem
	output reg[1:0] mux_2,       //mux_mem
	output reg mux_3,            //shift_source
	output reg mux_4,            //shamt
	output reg[2:0] mux_6,       //regDST
	output reg[3:0] mux_7,       //mem_to_reg
	output reg[1:0] mux_8,       //ALUSourceA
	output reg[2:0] mux_9,       //ALUSourceB
	output reg[2:0] mux_10,      //mux_to_pc
	output reg[1:0] mux_11,      //mux_to_mem_to_reg
	output reg shift_control,
	output reg ss_control,
	output reg mem_write,
	output reg [1:0] mult_div,
	output reg ir_write,
	output reg hi_lo,
	output reg EPC_CONTROL,
	output reg MDR_CONTROL,
	output reg LOAD_SIZE,
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

parameter RESET = 8'b00000000;
parameter FETCH = 8'd1;
parameter FETCH_2 = 8'd2;
parameter WAIT = 8'd3;
parameter DECODE = 8'd4;
parameter ADD = 8'd5;
parameter AND = 8'd6;
parameter SUB = 6'd63; // <-------------- MUDAR DEPOIS!!!!!!!!
//INCONSISTENCIA
parameter WRITE_ARIT = 8'd7;
parameter SHIFT_SHAMT = 8'd8;
parameter SLL = 8'd9;
parameter SRA = 8'd10;
parameter SRL = 8'd11;
parameter SHIFT_REG = 8'd12;
parameter SLLV = 8'd13;
parameter SRAV = 8'd14;
parameter WRITERD_SHIFT = 8'd15;
parameter MFHI = 8'd16;
parameter MFLO = 8'd17;
parameter SLT = 8'd18;
parameter JR = 8'd19;
parameter RTE = 8'd20;
parameter BREAK = 8'd21;
parameter MULT_LOAD = 8'd22;
parameter MULT_CALC = 8'd23;
parameter MULT_RESULT = 8'd24;
parameter DIV_LOAD = 8'd25;
parameter DIV_CALC = 8'd26;
parameter DIV_RESULT = 8'd27;
parameter JAL = 8'd28;
parameter RETURN_ADDRESS = 8'd29;
parameter J = 8'd30;
parameter INCDEC = 8'd31;
parameter INCDEC_WAIT = 8'd32;
parameter DEC_OP = 8'd33;
parameter INC_OP = 8'd34;
parameter INCDEC_ST = 8'd35;
parameter ADDIU = 8'd36;
parameter ADDI = 8'd37;
parameter BEQ = 8'd39;
parameter BNE = 8'd40;
parameter BLE = 8'd41;
parameter BGT = 8'd42;
parameter LUI = 8'd43;
parameter SLTI = 8'd44;
parameter LS_CALC = 8'd45;
parameter LS_START = 8'd46;
parameter LS_WAIT = 8'd47;
parameter SB_END = 8'd48;
parameter SH_END = 8'd49;
parameter SW_END = 8'd50;
parameter LB_END = 8'd51;
parameter LH_END = 8'd52;
parameter LW_END = 8'd53;
parameter OVERFLOW = 8'd54;
parameter DIVZERO = 8'd55;
parameter NOPCODE = 8'd56;
parameter EXP_WAIT = 8'd57;
parameter EXP_WRITE = 8'd58;
parameter WAIT_2 = 8'd59;
parameter INCDEC_WAIT_2 = 8'd60;
parameter LS_WAIT_2 = 8'd61;
parameter EXP_WAIT_2 = 8'd62;

parameter FINAL = 8'd255;

always@(posedge clock) begin
	if (reset) begin
		next_state = 8'b00000000;
	end	

	case(next_state)
		8'b00000000: begin
			pc_write = 1'b0;
			mux_1 = 2'b0;
			mux_2 = 2'b0;
			mux_3 = 1'b0;
			mux_4 = 1'b0;
			mux_6 = 3'b100; //ERRADO, é pra ser 11, q é igual a 29
			mux_7 = 4'b111;
			mux_8 = 2'b0;
			mux_9 = 3'b0;
			mux_10 = 3'b0;
			mux_11 = 1'b0;
			shift_control = 1'b0;
			ss_control = 1'b0;
			mem_write = 1'b0;
			mult_div = 2'b0;
			ir_write = 1'b0;
			hi_lo = 1'b0;
			EPC_CONTROL = 1'b0;
			MDR_CONTROL = 1'b0;
			LOAD_SIZE = 1'b0;
			ALU_CONTROL = 3'b0;
			ALU_OUT = 1'b0;
			REG_A = 2'b0;
			REG_B = 2'b0;
			REG_WRITE = 1'b1;
			XCH_CONTROL = 1'b0;
			
			next_state = 8'b00000001;
		end
		8'b00000001: begin
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
            shift_control = 1'b0;
            ss_control = 1'b0;
            mem_write = 1'b0;
            mult_div = 2'b0;
            ir_write = 1'b1;      //escreve a instrucao em ir_write
            hi_lo = 1'b0;
            EPC_CONTROL=1'b0;
            MDR_CONTROL = 1'b0;
            LOAD_SIZE = 1'b0;
            ALU_CONTROL=3'b1;     //faz PC+4
            ALU_OUT=1'b0;
            REG_A=2'b0;
            REG_B=2'b0;
            REG_WRITE = 1'b0;
            XCH_CONTROL = 1'b0;
			
			if(counter == 8'd1) begin
				counter = 8'd0;
				next_state = 8'b00000010;
			end
			else begin
				counter = counter + 8'd1;
			end

		end
		8'b00000010: begin
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
            shift_control = 1'b0;
            ss_control = 1'b0;
            mem_write = 1'b0;
            mult_div = 2'b0;
            ir_write = 1'b0; // de 1'b0 para 1'b1 
            hi_lo = 1'b0;
            EPC_CONTROL=1'b0;
            MDR_CONTROL = 1'b0;
            LOAD_SIZE = 1'b0;
            ALU_CONTROL=3'b1;
            ALU_OUT=1'b0;
            REG_A=2'b0;
            REG_B=2'b0;
            REG_WRITE = 1'b0;
            XCH_CONTROL = 1'b0;

			next_state = 8'b00000011;
			counter = 8'd0;
		end
		8'b00000011: begin
			pc_write=1'b0; //PC agora e PC+4
			mux_2=2'b0;
			mux_1=2'b0;
			mem_write=1'b0;      // --> ERRADO <-- coloca rs e rt no banco de registradores
			ss_control=1'b0;
			mult_div=2'b0;
			hi_lo=1'b0;
			ir_write=1'b0;
			MDR_CONTROL=1'b0;
			LOAD_SIZE=1'b0;
			mux_4=1'b0;
			mux_3=1'b0;
			shift_control=1'b0;
			mux_11=1'b0;
			mux_7=4'b0;
			mux_6=3'b0;
			REG_WRITE=1'b0;
			mux_8=2'b0;                     //escolhe PC
			mux_9=3'b100;             //        //->ERRADO, acho q deveria ser b1000 <-escolhe sinal extendido e shiftado de 15-0
			ALU_CONTROL=3'b1;               //ERRADO, soma é b1 <- faz PC+o escrito acima
			ALU_OUT=1'b1;                   //salva a soma em ALU_OUT
			EPC_CONTROL=1'b0;
			mux_10=3'b0;
			
			REG_A=2'b1;//load rs em a // ERRADO, é pra ser b1 pra dar write;
			REG_B=2'b1;//load rt em b // ERRADO, é pra ser b1 pra dar write;
			case(opcode) // essa linha tem que estar dentro de um estado tbm
				6'b0: begin // caso formato r
					case(funct)
						6'h20: next_state = 8'b00000100;
                        6'h24: next_state = 8'b00000100;
                        6'h22: next_state = 8'b00000100;
                        6'h0: next_state = 8'b00000100;
                        6'h2: next_state = 8'b00000100;
                        6'h3: next_state = 8'b00000100;
                        6'h4: next_state = 8'b00000100;
                        6'h7: next_state = 8'b00000100;
                        6'h10: next_state = 8'b00000100;
                        6'h12: next_state = 8'b00000100;
                        6'h2a: next_state = 8'b00000100;
                        6'h8: next_state = 8'b00000100;
                        6'h13: next_state = 8'b00000100;
                        6'hd: next_state = 8'b00000100;
                        6'h18: next_state = 8'b00000100;
                        6'h1a: next_state = 8'b00000100;
                    endcase
                end
 
                6'h3: next_state = 8'b00000100;
                6'h2: next_state =8'b00000100;
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
                default: next_state = 8'b00000100;
            endcase
		end
			
		8'b00000100: begin
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
			shift_control=1'b0;
			ss_control=1'b0;
			mem_write=1'b0;
			mult_div=2'b0;
			ir_write=1'b0;    
			hi_lo=1'b0;
			EPC_CONTROL=1'b0;
			MDR_CONTROL=1'b0;
			LOAD_SIZE=1'b0;
			ALU_CONTROL=3'b1;//soma A + B
			ALU_OUT=1'b1;//salva A+B em ALU_OUT
			REG_A=2'b0;
			REG_B=1'b0;
			REG_WRITE=1'b0;
			XCH_CONTROL = 1'b0;
			next_state = 8'b00000101; // next_state = ADD/AND/SUB_2;
		end
		8'b00000101: begin //tem q criar esse parametro
			pc_write=1'b0;
			mux_1=2'b0;
			mux_2=2'b0;
			mux_3=1'b0;
			mux_4=1'b0;
			mux_6=3'b10;//escolhe rd
			mux_7=4'b0;// escolhe o que está em ALU_OUT
			mux_8=2'b0;
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
			LOAD_SIZE=1'b0;
			ALU_CONTROL=3'b0;
			ALU_OUT=1'b0;
			REG_A=2'b0;
			REG_B=1'b0;
			REG_WRITE=1'b1;//permite escrever no banco de regs
			XCH_CONTROL = 1'b0;
			next_state = 8'b00000110;
		end
		8'b00000110: begin // tem q criar esse parametro
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
			shift_control=1'b0;
			ss_control=1'b0;
			mem_write=1'b0;
			mult_div=2'b0;
			ir_write=1'b0;    
			hi_lo=1'b0;
			EPC_CONTROL=1'b0;
			MDR_CONTROL=1'b0;
			LOAD_SIZE=1'b0;
			ALU_CONTROL=3'b0;
			ALU_OUT=1'b0;
			REG_A=2'b0;
			REG_B=1'b0;
			REG_WRITE=1'b0;
			XCH_CONTROL = 1'b0;
			next_state = 8'b00000001;
		end
    endcase
	
end
endmodule
