.data

A: .word -2
B: .word -1
X: .word 0
#if{(a >= 0 && a < b) -> x = 1}
#else if{(a < 0 && a > b) -> x = 2}
#else{x = 3}

#alocar as vari�veis A, B, X
.text
lw $t1, A
lw $t2, B
lw $t3, X

#definir 1, 2, 3, respectivamente
addi $s0, $zero, 1
addi $s1, $s0, 1   
addi $s2, $s1, 1  

#se A = 0 � um caso especial
beq $t1, $zero, AEZ

#valor de A > 0 � salvo em t4
slt $t4, $zero, $t1
#valor de A > B salvo em t5
slt $t5, $t1, $t2
#valor de (A < 0 & A > B) � salvo em t6
and $t6, $t4, $t5
#Se a proposi��o da linha 29 � satisfeita, entra-se no IF
beq $t6, $s0, IF
#Caso contr�rio:
#valor de A < 0 � salvo em t4
slt $t4, $t1, $zero
#valor de A > B � salvo em t5
slt $t5, $t2, $t1
#valor de (A < 0 & A > B) � salvo em t6
and $t6, $t4, $t5
#Se a proposi��o da linha 44 for verdade, entra-se no ELSEIF
beq $t6, $s0, ELSEIF
#Caso nenhuma das duas proposi��es sejam verade,
#3 � gravado em X
OK:
	sw $s2, X
	j Endif
AEZ: 
	#salvo em t5 se B > A
	slt $t5, $t1, $t2
	#Se sim, IF � satisfeito
	beq $t5, $s0, IF
	#Se n�o, vai pra OK
	j OK
IF:
	sw $s0, X
	j Endif

ELSEIF:
	sw $s1, X 
Endif:
