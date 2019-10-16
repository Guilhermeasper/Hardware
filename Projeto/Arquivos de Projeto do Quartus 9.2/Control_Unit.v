
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
	output reg mux_3,             //shift_source
	output reg mux_4,             //shamt
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
	output reg ALU_CONTROL,
	output reg ALU_OUT,
	output reg REG_A,
	output reg REG_B,
	output reg REG_WRITE,
	output reg XCH_CONTROL
);

integer counter;
reg[7:0] state;
reg [5:0]next_state;
reg[1:0] stateOverflow;

initial begin
    state = 8'b0;
    stateOverflow = 2'b0;
    counter = 0;
    next_state = 8'b0;
end

parameter RESET = 6'd0;
parameter FETCH = 6'd1;
parameter FETCH_2 = 6'd2;
parameter WAIT = 6'd4;
parameter DECODE = 6'd5;
parameter ADD = 6'd6;
parameter AND = 6'd7;
parameter SUB = 6'd8;
//INCONSISTENCIA
parameter WRITERD_ARIT = 6'd7;
parameter SHIFT_SHAMT = 6'd8;
parameter SLL = 6'd9;
parameter SRA = 6'd10;
parameter SRL = 6'd11;
parameter SHIFT_REG = 6'd12;
parameter SLLV = 6'd13;
parameter SRAV = 6'd14;
parameter WRITERD_SHIFT = 6'd15;
parameter MFHI = 6'd16;
parameter MFLO = 6'd17;
parameter SLT = 6'd18;
parameter JR = 6'd19;
parameter RTE = 6'd20;
parameter BREAK = 6'd21;
parameter MULT_LOAD = 6'd22;
parameter MULT_CALC = 6'd23;
parameter MULT_RESULT = 6'd24;
parameter DIV_LOAD = 6'd25;
parameter DIV_CALC = 6'd26;
parameter DIV_RESULT = 6'd27;
parameter JAL = 6'd28;
parameter RETURN_ADDRESS = 6'd29;
parameter J = 6'd30;
parameter INCDEC = 6'd31;
parameter INCDEC_WAIT = 6'd32;
parameter DEC_OP = 6'd33;
parameter INC_OP = 6'd34;
parameter INCDEC_ST = 6'd35;
parameter ADDIU = 6'd36;
parameter ADDI = 6'd37;
parameter BEQ = 6'd39;
parameter BNE = 6'd40;
parameter BLE = 6'd41;
parameter BGT = 6'd42;
parameter LUI = 6'd43;
parameter SLTI = 6'd44;
parameter LS_CALC = 6'd45;
parameter LS_START = 6'd46;
parameter LS_WAIT = 6'd47;
parameter SB_END = 6'd48;
parameter SH_END = 6'd49;
parameter SW_END = 6'd50;
parameter LB_END = 6'd51;
parameter LH_END = 6'd52;
parameter LW_END = 6'd53;
parameter OVERFLOW = 6'd54;
parameter DIVZERO = 6'd55;
parameter NOPCODE = 6'd56;
parameter EXP_WAIT = 6'd57;
parameter EXP_WRITE = 6'd58;
parameter WAIT_2 = 6'd59;
parameter INCDEC_WAIT_2 = 6'd60;
parameter LS_WAIT_2 = 6'd61;
parameter EXP_WAIT_2 = 6'd62;

always@(posedge clock or posedge reset) begin
	if (reset)
		state = RESET;
	else
		state = next_state;
end 

always@(posedge clock) begin
	case(state)
		RESET: begin
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
			
			next_state = FETCH;
		end
		FETCH: begin
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
            
            next_state = FETCH_2;
		end
		FETCH_2: begin
			pc_write = 1'b1;
            mux_1 = 2'b0;
            mux_2 = 2'b0;         
            mux_3 = 1'b0;
            mux_4 = 1'b0;
            mux_6 = 3'b0;
            mux_7 = 4'b0;
            mux_8 = 2'b0;         
            mux_9 = 3'b0;         
            mux_10= 3'b0;          
            mux_11 = 1'b0;
            shift_control = 1'b0;
            ss_control = 1'b0;
            mem_write = 1'b0;
            mult_div = 2'b0;
            ir_write = 1'b1; // de 1'b0 para 1'b1 
            hi_lo = 
            EPC_CONTROL=1'b0;
            MDR_CONTROL = 1'b0;
            LOAD_SIZE = 1'b0;
            ALU_CONTROL=3'b0;
            ALU_OUT=1'b0;
            REG_A=2'b0;
            REG_B=2'b0;
            REG_WRITE = 1'b0;
            XCH_CONTROL = 1'b0;

			next_state = WAIT;
		end
		WAIT: begin
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

			next_state = DECODE; //ERRADO, gera loop infinito -> CONSERTADO: de WAIT para DECODE.
		end
		DECODE: begin
			pc_write=1'b0; //PC agora e PC+4
			mux_2=2'b0;
			mux_1=2'b0;
			mem_write=1'b1;      // --> ERRADO <-- coloca rs e rt no banco de registradores
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
			mux_9=3'b0;                     //->ERRADO, acho q deveria ser b1000 <-escolhe sinal extendido e shiftado de 15-0
			ALU_CONTROL=3'b0;               //ERRADO, soma é b1 <- faz PC+o escrito acima
			ALU_OUT=1'b1;                   //salva a soma em ALU_OUT
			EPC_CONTROL=1'b0;
			mux_10=3'b0;
			REG_A=2'b0;//load rs em a // ERRADO, é pra ser b1 pra dar write;

			REG_B=2'b0;//load rt em b // ERRADO, é pra ser b1 pra dar write;
			
			case(opcode) // essa linha tem que estar dentro de um estado tbm
				6'b0: begin // caso formato r
					case(funct)
						6'h20: next_state = ADD;
                        6'h24: next_state = AND;
                        6'h22: next_state = SUB;
                        6'h0: next_state = SHIFT_SHAMT;
                        6'h2: next_state = SHIFT_SHAMT;
                        6'h3: next_state = SHIFT_SHAMT;
                        6'h4: next_state = SHIFT_REG;
                        6'h7: next_state = SHIFT_REG;
                        6'h10: next_state = MFHI;
                        6'h12: next_state = MFLO;
                        6'h2a: next_state = SLT;
                        6'h8: next_state = JR;
                        6'h13: next_state = RTE;
                        6'hd: next_state = BREAK;
                        6'h18: next_state = MULT_LOAD;
                        6'h1a: next_state = DIV_LOAD;
                    endcase
                end
 
                6'h3: next_state = JAL;
                6'h2: next_state = J;
                6'h10: next_state = INCDEC;
                6'h11: next_state = INCDEC;
                6'h8: next_state = ADDI;
                6'h9: next_state = ADDIU;
                6'h4: next_state = BEQ;
                6'h5: next_state = BNE;
                6'h6: next_state = BLE;
                6'h7: next_state = BGT;
                6'hf: next_state = LUI;
                6'ha: next_state = SLTI;
                6'h28: next_state = LS_CALC;
                6'h29: next_state = LS_CALC;
                6'h2b: next_state = LS_CALC;
                6'h20: next_state = LS_CALC;
                6'h21: next_state = LS_CALC;
                6'h23: next_state = LS_CALC;
                default: next_state = NOPCODE;
            endcase
		end
		ADD: begin
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
			next_state = ADD/AND/SUB_2;
		end;
		ADD/AND/SUB_2: begin //tem q criar esse parametro
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
			next_state = FINAL;
		end;
		FINAL: begin // tem q criar esse parametro
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
			next_state = FETCH;
		end;
    endcase
	
end
endmodule
