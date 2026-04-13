main:
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
