  .section ".text.init","ax",@progbits
  .globl _start
  .align 2
_start:
  # li a0, 0x10
  # li a1, 0x0

  # csrrs	t0,minstret,zero

  # # li t0, 0
  # sw t0, (a0)
  sw zero, (zero)

infinite_loop0:
  j infinite_loop0

.section ".trap_handler","ax",@progbits
trap_handler:

  li t0, 1
  sw t0, (a0)
  sw zero, (zero)

infinite_loop1:
  j infinite_loop1