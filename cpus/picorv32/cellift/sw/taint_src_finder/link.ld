OUTPUT_ARCH( "riscv" )
ENTRY(_start)

SECTIONS
{
  . = 0x80000000;
  .text.init : { *(.text.init) }
  . = ALIGN(0x1000);
  .intdata0 = .;
  . += 100;
  . = ALIGN(0x4000);
  .trap_handler = 0x80004000;
}
