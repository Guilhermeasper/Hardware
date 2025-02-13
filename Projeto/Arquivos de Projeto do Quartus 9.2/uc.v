//tive q comecar do zero pq o pc travou na linha 77 sem eu ter salvo ;))))))))
module uc(
    input clock,
    input igual,
    input menor,
    input maior,
    input wire [5:0]opcode,
    input wire [5:0]funct,
    input div0,
    input overflow,
    input reset,
    input negativo,
    output reg pc_write,
    output reg[1:0]mux_mem,
    output reg[1:0]mux_to_mux_mem,
    output reg mem_write,
    output reg ss_control,
    output reg[1:0]mult_div,
    output reg hilo,
    output reg ir_write,
    output reg mdr_write,
    output reg ls_control,
    output reg shamt,
    output reg shift_source,
    output reg shift_control,
    output reg mux_to_mem_to_reg,
    output reg[3:0]mem_to_reg,
    output reg[2:0]regDST,
    output reg reg_write,
    output reg xch,
    output reg[1:0]ALUSourceA,
    output reg[2:0]ALUSourceB,
    output reg[2:0] ALUControl,
    output reg ALUOut,
    output reg epc,
    output reg[2:0]mux_to_pc,
    output reg a,
    output reg b
); 
integer contador;
reg[7:0] estado;
reg[1:0] estadoOverflow;

initial begin
    estado = 8'b0;
    estadoOverflow = 2'b0;
    contador = 0;
end

always@(posedge clock)begin
    if(reset)begin
        pc_write=1'b0;
        mux_mem=2'b0;
        mux_to_mux_mem=2'b0;
        mem_write=1'b0;
        ss_control=1'b0;
        mult_div=2'b0;
        hilo=1'b0;
        ir_write=1'b0;
        mdr_write=1'b0;
        ls_control=1'b0;
        shamt=1'b0;
        shift_source=1'b0;
        shift_control=1'b0;
        mux_to_mem_to_reg=1'b0;
        mem_to_reg=4'b111;//escolhe o 227
        regDST=3'b100;//escolhe o 31
        reg_write=1'b1;//escreve em reg
        xch=1'b0;
        ALUSourceA=2'b0;
        ALUSourceB=3'b0;
        ALUControl=3'b0;
        ALUOut=1'b0;
        epc=1'b0;
        mux_to_pc=3'b0;
        a=2'b0;
        b=2'b0;
    end
    else if(overflow && opcode!=6'b001001)begin
        case(estadoOverflow)
            2'b0: begin//overflow 1
                pc_write=1'b0;
                mux_mem=2'b10;//escolhe o mux_to_mux_mem
                mux_to_mux_mem=2'b0;//escolhe o 253
                mem_write=1'b0;
                ss_control=1'b0;
                mult_div=2'b0;
                hilo=1'b0;
                ir_write=1'b0;
                mdr_write=1'b0;
                ls_control=1'b0;
                shamt=1'b0;
                shift_source=1'b0;
                shift_control=1'b0;
                mux_to_mem_to_reg=1'b0;
                mem_to_reg=4'b0;
                regDST=3'b0;
                reg_write=1'b0;
                xch=1'b0;
                ALUSourceA=2'b0;//escolhe PC
                ALUSourceB=3'b1;//escolhe 4
                ALUControl=3'b10;//faz PC-4
                ALUOut=1'b0;
                epc=1'b1;//salva PC-4 em epc
                mux_to_pc=3'b0;
                a=2'b0;
                b=2'b0;  
                estadoOverflow= 2'b1;
            end
            2'b1: begin//overflow 2
                pc_write=1'b0;
                mux_mem=2'b0;
                mux_to_mux_mem=2'b0;
                mem_write=1'b0;
                ss_control=1'b0;
                mult_div=2'b0;
                hilo=1'b0;
                ir_write=1'b0;
                mdr_write=1'b1;//escreve oq ta em 253 em mdr e extende o sinal
                ls_control=1'b0;
                shamt=1'b0;
                shift_source=1'b0;
                shift_control=1'b0;
                mux_to_mem_to_reg=1'b0;
                mem_to_reg=4'b0;
                regDST=3'b0;
                reg_write=1'b0;
                xch=1'b0;
                ALUSourceA=2'b1;//escolhe mdr extendido
                ALUSourceB=3'b0;
                ALUControl=3'b0;//da hold em mdr extendido
                ALUOut=1'b0;
                epc=1'b0;
                mux_to_pc=3'b0;//escolhe mdr extendido
                a=2'b0;
                b=2'b0;  
                estadoOverflow= 2'b10;
            end
            2'b10: begin//overflow 3
                pc_write=1'b1;//escreve mdr extendido em pc
                mux_mem=2'b0;
                mux_to_mux_mem=2'b0;
                mem_write=1'b0;
                ss_control=1'b0;
                mult_div=2'b0;
                hilo=1'b0;
                ir_write=1'b0;
                mdr_write=1'b0;
                ls_control=1'b0;
                shamt=1'b0;
                shift_source=1'b0;
                shift_control=1'b0;
                mux_to_mem_to_reg=1'b0;
                mem_to_reg=4'b0;
                regDST=3'b0;
                reg_write=1'b0;
                xch=1'b0;
                ALUSourceA=2'b0;
                ALUSourceB=3'b0;
                ALUControl=3'b0;
                ALUOut=1'b0;
                epc=1'b0;
                mux_to_pc=3'b0;
                a=2'b0;
                b=2'b0;  
                estadoOverflow= 2'b11;
            end
            2'b11: begin//overflow 4
                pc_write=1'b0;//esse estado so serve pra fechar o pc_write
                mux_mem=2'b0;
                mux_to_mux_mem=2'b0;
                mem_write=1'b0;
                ss_control=1'b0;
                mult_div=2'b0;
                hilo=1'b0;
                ir_write=1'b0;
                mdr_write=1'b0;
                ls_control=1'b0;
                shamt=1'b0;
                shift_source=1'b0;
                shift_control=1'b0;
                mux_to_mem_to_reg=1'b0;
                mem_to_reg=4'b0;
                regDST=3'b0;
                reg_write=1'b0;
                xch=1'b0;
                ALUSourceA=2'b0;
                ALUSourceB=3'b0;
                ALUControl=3'b0;
                ALUOut=1'b0;
                epc=1'b0;
                mux_to_pc=3'b0;
                a=2'b0;
                b=2'b0;  
                estadoOverflow= 2'b0;
            end
        endcase
    end
    else begin
        case(estado)
            8'b0: begin//fetch 1
                pc_write=1'b0;
                mux_mem=2'b0;//escolhe o PC
                mux_to_mux_mem=2'b0;
                mem_write=1'b0;
                ss_control=1'b0;
                mult_div=2'b0;
                hilo=1'b0;
                ir_write=1'b1;//escreve a instrucao em ir_write
                mdr_write=1'b0;
                ls_control=1'b0;
                shamt=1'b0;
                shift_source=1'b0;
                shift_control=1'b0;
                mux_to_mem_to_reg=1'b0;
                mem_to_reg=4'b0;
                regDST=3'b0;
                reg_write=1'b0;
                xch=1'b0;
                ALUSourceA=2'b0;//escolhe PC
                ALUSourceB=3'b1;//escolhe 4
                ALUControl=3'b1;//faz PC+4
                ALUOut=1'b0;
                epc=1'b0;
                mux_to_pc=3'b0;//escolhe PC+4
                a=2'b0;
                b=2'b0;  
                estado= 8'b1;
            end
            8'b1: begin//fetch 2
                pc_write=1'b1;//PC agora e PC+4
                mux_mem=2'b0;
                mux_to_mux_mem=2'b0;
                mem_write=1'b1;//coloca rs e rt no banco de registradores
                ss_control=1'b0;
                mult_div=2'b0;
                hilo=1'b0;
                ir_write=1'b0;
                mdr_write=1'b0;
                ls_control=1'b0;
                shamt=1'b0;
                shift_source=1'b0;
                shift_control=1'b0;
                mux_to_mem_to_reg=1'b0;
                mem_to_reg=4'b0;
                regDST=3'b0;
                reg_write=1'b0;
                xch=1'b0;
                ALUSourceA=2'b0;//escolhe PC
                ALUSourceB=3'b101;//escolhe sinal extendido e shiftado de 15-0
                ALUControl=3'b1;//faz PC+o escrito acima
                ALUOut=1'b1;//salva a soma em aluout
                epc=1'b0;
                mux_to_pc=3'b0;//escolhe PC+4
                a=2'b1;//load rs em a
                b=2'b1;//load rt em b  
                estado=8'b10;
            end
            8'b10: begin//aqui começam as instruções de fato
                case(opcode)
                    6'b0: begin // caso formato r
                        case(funct)
                            6'b100000: begin//instrucao ADD!!!!
                                    pc_write=1'b0;
                                    mux_mem=2'b0;
                                    mux_to_mux_mem=2'b0;
                                    mem_write=1'b0;
                                    ss_control=1'b0;
                                    mult_div=2'b0;
                                    hilo=1'b0;
                                    ir_write=1'b0;
                                    mdr_write=1'b0;
                                    ls_control=1'b0;
                                    shamt=1'b0;
                                    shift_source=1'b0;
                                    shift_control=1'b0;
                                    mux_to_mem_to_reg=1'b0;
                                    mem_to_reg=4'b0;
                                    regDST=3'b0;
                                    reg_write=1'b0;
                                    xch=1'b0;
                                    ALUSourceA=2'b10;//escolha A
                                    ALUSourceB=3'b0;//escolhe B
                                    ALUControl=3'b1;//faz A+B
                                    ALUOut=1'b1;//salva a soma em aluout
                                    epc=1'b0;
                                    mux_to_pc=3'b0;
                                    a=2'b0;
                                    b=2'b0;
                                    estado = 8'b11;
                                end
                        endcase
                    end
                endcase
            end
            8'b11: begin //add pt 2
				pc_write=1'b0;
                mux_mem=2'b0;
                mux_to_mux_mem=2'b0;
                mem_write=1'b0;
                ss_control=1'b0;
                mult_div=2'b0;
                hilo=1'b0;
                ir_write=1'b0;
                mdr_write=1'b0;
                ls_control=1'b0;
                shamt=1'b0;
                shift_source=1'b0;
                shift_control=1'b0;
                mux_to_mem_to_reg=1'b0;
                mem_to_reg=4'b0;//escolhe o aluout
                regDST=3'b10;//escolhe o rd
                reg_write=1'b1;//escreve no banco de regs
                xch=1'b0;
                ALUSourceA=2'b0;
                ALUSourceB=3'b0;
                ALUControl=3'b0;
                ALUOut=1'b0;
                epc=1'b0;
                mux_to_pc=3'b0;
                a=2'b0;
                b=2'b0;
                estado = 8'b11111111;
			end
			8'b11111111: begin //fecha tudo
				pc_write=1'b0;
                mux_mem=2'b0;
                mux_to_mux_mem=2'b0;
                mem_write=1'b0;
                ss_control=1'b0;
                mult_div=2'b0;
                hilo=1'b0;
                ir_write=1'b0;
                mdr_write=1'b0;
                ls_control=1'b0;
                shamt=1'b0;
                shift_source=1'b0;
                shift_control=1'b0;
                mux_to_mem_to_reg=1'b0;
                mem_to_reg=4'b0;
                regDST=3'b0;
                reg_write=1'b0;
                xch=1'b0;
                ALUSourceA=2'b0;
                ALUSourceB=3'b0;
                ALUControl=3'b0;
                ALUOut=1'b0;
                epc=1'b0;
                mux_to_pc=3'b0;
                a=2'b0;
                b=2'b0;
                estado = 8'b0;
			end
        endcase
    end
  end
endmodule