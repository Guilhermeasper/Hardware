.data

A: .word 1
B: .word 3
SUM: .word 0
V: .word 0

.text
lw $a0, A 
lw $a1, B 
lw $a2, SUM
lw $v1, V

addi $s0, $zero, 1 # Define $s0 igual a 1

sle $t1, $a0, $a1 # Verifica se A é menor ou igual a B
beqz  $t1, ZERO # Se A for maior que B, vai para o label ZERO
jal sum # Primeira chamada da função
j Endif # Quando a função terminar termine o programa

sum:
	addi $sp, $sp, -12 #Aloca a fila para 12 bytes(3 elementos
	sw  $ra, 0($sp) # Salva o endereço de retorno
    	sw  $a0, 4($sp) # Salva $a0 na pilha
    	sw  $a2, 8($sp) # Salva $a2 na pilha
    	bne $a0, $a1, dif # Verifica se A é diferente de B, se não vai para o caso base
    	# -----  Caso Base A == B --------
	add $a2, $a2, $a0 # Soma A ao SUM
    	add $v0, $zero, $a2 # Adiciona o SUM a $v0
    	lw $a0, 4($sp) # Restaura o A original
	lw $ra, 0($sp) # Restaura o endereço de retorno
    	addi $sp, $sp, 12 # Retira os 3 elementos da pilha
    	jr $ra # Faz o retorno quebrando a função recursiva
    	# ----- Fim do caso Base ------
	dif: # Caso A != B 
		add $a2, $a2, $a0 # Soma A ao SUM
		addi $a0, $a0, 1 # Incrementa A
		jal sum # Chamada Recursiva
		j Endif # Vai para o fim do programa
ZERO: # Caso A != B
	addi $v1, $zero, 1 # Define o regs $v1 = 1
Endif:
