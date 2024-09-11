
  .section ".text.init","ax",@progbits
  .globl _start
  .align 2
_start:


nop
nop
# Load 0xAAAAA2AA into t1
# = binary 10101010101010101010101010101010
# 0xAAA
lui t1, 0xAAAAA
addi t1, t1, 0x2AA

nop
nop
nop
addi t2, x0, 3

nop
nop
nop
sll t3, t1, t2
nop
nop
nop
wfi