  .section ".text.init","ax",@progbits
  .globl _start
  .align 2
_start:

  csrrw zero, mvendorid, zero

  nop
  nop

  wfi

infinite_loop1:
  j infinite_loop1