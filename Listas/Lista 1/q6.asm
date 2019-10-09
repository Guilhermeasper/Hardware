.data
Primo: .word 2, 3, 5, 7 #array para consulta
A: .word 2, 4, 10, 23, 37, 12 #array para entrada
B: .word 0, 0, 0, 0, 0 #array armazenando a resposta
LeI: .word 24 #tamanho do array entrada
#t0 e t5 � zero (ser�o contadores) :)

.text
li $t1,  20 #tamanho do array com primos est� em t0
lw $s0, LeI #tamanho do array de entrada � salvo em s0
la $t7, A #colocando em t7 a primeira posi��o de A

main:
	li $t2, 0 #em t2 est� um contador, que � resetado no come�o da fun��o main
	beq $t0, $s0, end #se t0 for maior que o tamanho de A,  cab�
	lw $s1, A($t0) #s1 recebe o valor que est� em t0 no array de entrada
	addi $t0, $t0, 4 #incrementa t0 em 1
	
isPrimo:
	beq $t2, $t1, moveEl #se t2 for maior que t1, cab�
	lw $t3, Primo($t2) #� salvo em t3 o n�mero primo que est� sendo testado
	addi $t2, $t2, 4 #incrementa t2 em 1
	beq $s1, $t3, moveEl # vai para moveEl se A em t0 est� em Primo[t2]
	div $s1, $t3 #Divide s1 por t3
	mfhi $t4 #coloca em t4 o resto da divis�o
	beqz $t4, main #se t4 for 0, o n�mero n�o � primo, en�o volta pro main
	j isPrimo #recome�a utilizando o pr�ximo primo
moveEl:
	sw $s1, B($t5) #Coloca o valor testado no array de resposta(em t5)
	addi $t5, $t5, 4 #incrementa t5
	j main
end: