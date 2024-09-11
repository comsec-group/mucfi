
  .section ".text.init","ax",@progbits
  .globl _start
  .align 2
_start:
.rept 360
nop
.endr
la x7, taint_symbol_0
lw x8, (x7)
la x11, taint_symbol_0
lw x10, (x11)
instr_taint_symbol:
srl x8, x10, x0
nop
nop
sw x0, (x0)

infinite_loop:
    j infinite_loop

.section ".data"
.align 2
