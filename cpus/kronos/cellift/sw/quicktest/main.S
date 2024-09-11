
  .section ".text.init","ax",@progbits
  .globl _start
  .align 2
_start:
.rept 42
nop
.endr
la x5, taint_symbol_0
lw x12, (x5)
instr_taint_symbol:
ori x6, x12, -952
nop
nop
sw x6, (x0)
infinite_loop:
    j infinite_loop
.section ".taint_symbol_0","ax",@progbits
  .8byte 0x1946bacb7de25980
