
    OUTPUT_ARCH( "riscv" )
    ENTRY(_start)

    SECTIONS
    {
    . = 0x80000000;
    .text.init : { *(.text.init) }
    .data      : { *(.data) }
    . = ALIGN(0x4000);
    . += 8;
    taint_symbol_0 = .;

    }
