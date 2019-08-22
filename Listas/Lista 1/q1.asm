.data

A: .word 1
B: .word 1
R: .word 0


.text
lw $t1, A #A está em t1
lw $t2, B #B está em t2
lw $t3, R #R está em t3

####Definição de Variáveis
addi $s0, $zero, 1 ## $s0 é 1
addi $s1, $s0, 1   ## $s1 é 2
addi $s2, $s1, 1   ## $s2 é 3

slt $t4, $zero, $t1 #Checa se A > 0
slt $t5, $zero, $t2 #Checa se B > 0

and $t6, $t4, $t5 #Checa se ((A & B) > 0) == true

beq $t5, $zero, ELSE   #Se B <= 0, então ELSE
beq $t4, $zero, ELSEIF  #B > 0, então checa se A <= 0
sw $s0, R #OK IF, Coloca R = 1

j Endif ##Depois que acabar o if if if, pula pro fim do if.

ELSEIF: 	
	sw $s1, R #OK IF, Coloca R = 2
	j Endif
ELSE:
	sw $s2, R #OK IF, Coloca R = 3
Endif:
