
  .section ".text.init","ax",@progbits
  .globl _start
  .align 2
_start:

nop
nop
nop
addi t1, t0, 1
nop
addi t1, t1, 2
addi t1, t1, 3
nop
addi t1, t1, 4
addi t1, t1, 5
addi t1, t1, 6
jal our_label
nop
nop
our_label:
addi t1, t1, 7
nop
wfi