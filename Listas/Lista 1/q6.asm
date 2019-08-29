.data
Primo: .word 2, 3, 5, 7 #array para consulta
A: .word 2, 4, 10, 23, 37, 12 #array para entrada
B: .word 0, 0, 0, 0, 0 #array armazenando a resposta
LeI: .word 24 #tamanho do array entrada
#t0 e t5 é zero (serão contadores) :)

.text
li $t1,  20 #tamanho do array com primos está em t0
lw $s0, LeI #tamanho do array de entrada é salvo em s0
la $t7, A #colocando em t7 a primeira posição de A

main:
	li $t2, 0 #em t2 está um contador, que é resetado no começo da função main
	beq $t0, $s0, end #se t0 for maior que o tamanho de A,  cabô
	lw $s1, A($t0) #s1 recebe o valor que está em t0 no array de entrada
	addi $t0, $t0, 4 #incrementa t0 em 1
	
isPrimo:
	beq $t2, $t1, moveEl #se t2 for maior que t1, cabô
	lw $t3, Primo($t2) #é salvo em t3 o número primo que está sendo testado
	addi $t2, $t2, 4 #incrementa t2 em 1
	beq $s1, $t3, moveEl # vai para moveEl se A em t0 está em Primo[t2]
	div $s1, $t3 #Divide s1 por t3
	mfhi $t4 #coloca em t4 o resto da divisão
	beqz $t4, main #se t4 for 0, o número não é primo, enão volta pro main
	j isPrimo #recomeça utilizando o próximo primo
moveEl:
	sw $s1, B($t5) #Coloca o valor testado no array de resposta(em t5)
	addi $t5, $t5, 4 #incrementa t5
	j main
end: