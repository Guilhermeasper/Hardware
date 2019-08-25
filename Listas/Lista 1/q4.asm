.data

A: .word 1
B: .word 1
R: .word 0


.text
lw $t1, L1 #Lado 1 esta em $t1
lw $t2, L2 #Lado 2 esta em $t2
lw $t3, L3 #Lado 3 esta em $t3

####Definição de Variáveis
addi $s0, $zero, 1 ## $s0 é 1

#Verificando qual lado � o maior
sgt $t4, $t2, $t1
sgt $t5, $t2, $t3
and $t6, $t4, $t5

beq $t6, $s0, L2MAIOR

sgt $t4, $t3, $t1
sgt $t5, $t3, $t2
and $t6, $t4, $t5

beq $t6, $s0, L3MAIOR

L1MAIOR:
	add $t4, $t2, $t3
	bgt $t4, $t1, OK
	j ZERO
L2MAIOR:
	add $t4, $t2, $t3
	bgt $t4, $t1, OK
	j ZERO
L3MAIOR:
	add $t4, $t2, $t3
	bgt $t4, $t1, OK
	j ZERO
ZERO:
	sw $t7, $zero

OK:
	

Endif: