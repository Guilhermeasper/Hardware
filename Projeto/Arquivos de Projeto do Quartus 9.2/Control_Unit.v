
module Control_Unit(
	input clock;
	input equal;
	input less;
	input greater;
	input opcode[5:0];
	input funct[5:0];
	input div0;
	input overflow;
	input reset;
	input negative;
	output reg pc_write;
	output reg [1:0] mux_1;//mux_to_mux_mem
	output reg [1:0] mux_2;//mux_mem
	output reg mux_3;//shift_source
	output reg mux_4;//shamt
	output reg [2:0] mux_6;//regDST
	output reg [3:0] mux_7;//mem_to_reg
	output reg [1:0] mux_8;//ALUSourceA
	output reg [2:0] mux_9;//ALUSourceB
	output reg [2:0] mux_10;//mux_to_pc
	output reg [1:0] mux_11;//mux_to_mem_to_reg
	output reg shift_control;
	output reg ss_control;
	output reg mem_write;
	output reg [1:0] mult_div;
	output reg ir_write;
	output reg hi_lo;
	output reg EPC_CONTROL;
	output reg MDR_CONTROL;
	output reg LOAD_SIZE;
	output reg ALU_CONTROL;
	output reg ALU_OUT;
	output reg REG_A;
	output reg REG_B;
	output reg REG_WRITE;
	output reg XCH_CONTROL;
);
integer counter;
reg [7:0] state;
reg [1:0] stateOverflow;

initial begin
    state = 8'b0;
    stateOverflow = 2'b0;
    counter = 0;
end

parameter RESET = 6'd0;
parameter FETCH = 6'd1;
parameter WAIT = 6'd2;
parameter DECODE = 6'd3;
parameter ADD = 6'd4;
parameter AND = 6'd5;
parameter SUB = 6'd6;
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
parameter REG_WRITE = 6'd38;
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

reg [5:0]nextState;

always@(posedge clock or posedge reset) begin
	if (reset)
		state = RESET;
	else
		state = nextState;
end 

always@(posedge clock)begin
	case(state)
		RESET: begin
			pc_write = 1'b0;
			mux_1 = 2'b0;
			mux_2 = 2'b0;
			mux_3 = 1'b0;
			mux_4 = 1'b0;
			mux_6 = 3'b100;
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
			
			state = FETCH;
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
            
            state = FETCH_2;
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
            ir_write = 1'b0;
            hi_lo = 1'b0;
            EPC_CONTROL=1'b0;
            MDR_CONTROL = 1'b0;
            LOAD_SIZE = 1'b0;
            ALU_CONTROL=3'b0;
            ALU_OUT=1'b0;
            REG_A=2'b0;
            REG_B=2'b0;
            REG_WRITE = 1'b0;
            XCH_CONTROL = 1'b0;

			state = WAIT;
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
			ir_write=1'b1;
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

			state = WAIT;
		end
    endcase
	
end
endmodule