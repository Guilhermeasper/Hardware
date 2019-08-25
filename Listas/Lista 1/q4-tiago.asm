.data

L1: .word 1
L2: .word 2
L3: .word 3
R: .word 0


.text
lw $t1, L1 #Lado 1 esta em $t1
lw $t2, L2 #Lado 2 esta em $t2
lw $t3, L3 #Lado 3 esta em $t3
lw $t7, R #Resposta está em t7

####Definição de Variáveis
addi $s0, $zero, 1 ## $s0 é 1
addi $s1, $s0, 1 ##s1 é 2
addi $s2, $s1, 1 ##s2 é 3

#Verificando qual lado é o maior
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
	sw $zero, R

OK:
	#L1 = L2 || L1 = L3 || L2 = L3
	beq $t1, $t2, BEQ
	beq $t1, $t3, ISOSCELES
	beq $t2, $t3, ISOSCELES
	
	#salvando o triangulo como escaleno
	sw $s2, R
	
	j Endif
BEQ:
	#teste para ser equilátero.
	#se não for, ele é isósceles
	beq $t2, $t3 EQUILATERO
ISOSCELES:
	
	sw $s1, R
	
	j Endif
	
EQUILATERO:
	sw $s0, R
Endif: