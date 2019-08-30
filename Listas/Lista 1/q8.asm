# Fibonacci

.data
# Entrada
A: .word 3
X: .word 20

.text
lw $t1, A

addi $s1, $zero, 1 # const 1
addi $s3, $zero, 3 # const 3

addi $a0, $t1, 0
jal fib
sw $v0,X

j end

fib:
# prepara a pilha
addi $sp, $sp, -12 
sw   $ra, 0($sp)
sw   $s2, 4($sp)
sw   $s4, 8($sp)

slt $t0, $a0, $s3 # salva em t0 se o valor passado for menor que 3 (1 ou 2)
beq $t0, $s1, returnOne # verifica se é verdadeiro e pula para retornar 1

addi $s2, $a0, 0 # salva o argumento atual

# se for falso, continua e chama de novo fib
# chama fib(x-1) 
addi $a0, $s2, -1
jal fib
add $s4, $zero, $v0

# chama fib(x-2)
addi $a0, $s4, -2
jal fib

add $v0, $v0, $s2

j fibend

returnOne:
addi $v0, $zero, 1

fibend:
lw   $ra, 0($sp)  # pega da pilha
lw   $s2, 4($sp)
lw   $s4, 8($sp)
addi $sp, $sp, 12
jr $ra # finaliza a recursão

end: