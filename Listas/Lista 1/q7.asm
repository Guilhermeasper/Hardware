.data

A: .word 1
B: .word 9
SUM: .word 0
V: .word 0

.text
lw $a0, A 
lw $a1, B 
lw $a2, SUM
lw $v1, V

addi $s0, $zero, 1

slt $t1, $a0, $a1
beqz  $t1, ZERO

sum:
	addi $sp, $sp, -16 #Aloca a fila
	sw   $ra, 0($sp)
    	sw   $a0, 4($sp)
    	sw   $a1, 8($sp)
    	sw   $a2, 12($sp)
    	bne $a0, $a1, dif
    	add $v0, $zero, $a0
    	addi $sp, $sp, 16
    	jr $ra	 
	dif:
		add $a2, $a2, $a0
		addi $a0, $a0, 1
		jal sum
		lw $a2, 12($sp)
		lw $a1, 8($sp)
		lw $a2, 4($sp)
		lw $ra, 0($sp)
		add $v0, $v0, $a2
    		addi $sp, $sp, 16
    		jr $ra
ZERO:
	sw $s0, V
Endif: