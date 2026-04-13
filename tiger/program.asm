.text
	.globl main
main:
	li $t0, 42
	li $t1, 100
	mul $t2, $t0, $t0
	mul $t3, $t1, $t1
	add $t4, $t2, $t3
	li $t5, 2
	mul $t6, $t5, $t0
	mul $t7, $t6, $t1
	add $t8, $t4, $t7
	move $a0, $t8
	li $v0, 1
	syscall
	li $t0, 2
	li $t1, 3
	li $t2, 4
	mul $t3, $t1, $t2
	add $t4, $t0, $t3
	li $t0, 2
	li $t1, 40
	add $t2, $t1, $t0
	add $t3, $t2, $t0
	move $a0, $t3
	li $v0, 1
	syscall
	li $t4, 0
	li $t5, 100
L0:
	slt $t9, $t5, $t4
	bne $t9, $zero, L1
	move $a0, $t4
	li $v0, 1
	syscall
	li $t6, 1
	add $t4, $t4, $t6
	j L0
L1:
	move $a0, $t2
	li $v0, 1
	syscall
	li $v0, 10
	syscall
