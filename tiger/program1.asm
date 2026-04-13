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
li $v0, 10
syscall
