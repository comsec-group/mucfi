
  .section ".text.init","ax",@progbits
  .globl _start
  .align 2
_start:
.rept 25
nop
.endr
la x17, taint_symbol_0
lw x7, (x17)
la x27, randdata0
lw x5, (x27)
instr_taint_symbol:
sb x7, -652(x5)
nop
nop
sw x0, (x0)
infinite_loop:
    j infinite_loop
.section ".randdata0"
  .8byte 0xd9a2447d24b8a08d
.section ".taint_symbol_0"
  .8byte 0xb00a76a28cdc7b06
