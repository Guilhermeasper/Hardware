.data

A: .word 7
B: .word -7
RESULT: .word 0


.text
lw $t1, A #A esta em t1
lw $t2, B #B esta em t2
lw $t3, RESULT #RESULT esta em t3
addi $s0, $zero, 1

add $t4, $zero, $zero
add $t5, $zero, $zero

beqz $t1, ZERO

slt $t6, $t1, $zero
slt $t7, $t2, $zero

and $s1, $t6, $t7
beq $s1, $s0, MULT4

beq $t6, $s0, MULT2


MULT1:
	add $t4, $t4, $t2
	addi $t5, $t5, 1
	beq $t1, $t5, R
	j MULT1
MULT2:
	add $t4, $t4, $t1
	addi $t5, $t5, 1
	beq $t2, $t5, R
	j MULT2

MULT4:
	neg $t1, $t1
	neg $t2, $t2
	INSIDE:
		add $t4, $t4, $t2
		addi $t5, $t5, 1
		beq $t1, $t5, R
		j INSIDE
	
ZERO:
	sw $t4, RESULT
	j Endif
R:
	sw $t4, RESULT
Endif:
	
