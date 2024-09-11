
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
# Load 0xBBBBB2BB into t2
lui t2, 0xBBBBB
addi t2, t2, 0x2BB

nop
nop
nop
# The following add will retrieve the values from the regs and add them.
# Goal: find the "consumer" signals of the register values. These are the signals where we see the values of the registers at the latest
# point in simulation time
# (Hopefully they will not be copied anywhere else and not used)
add t3, t1, t2
nop
nop
nop
wfi