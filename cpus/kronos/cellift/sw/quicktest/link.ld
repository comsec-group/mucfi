
    OUTPUT_ARCH( "riscv" )
    ENTRY(_start)

    SECTIONS
    {
    . = 0x80;
    .text.init : { *(.text.init) }
    .data      : { *(.data) }
    randdata0 = ALIGN(0x8);
    . = randdata0;
    .randdata0  : { *(.randdata0) }
    randdata1 = ALIGN(0x8);
    . = randdata1;
    .randdata1  : { *(.randdata1) }
    randdata2 = ALIGN(0x8);
    . = randdata2;
    .randdata2  : { *(.randdata2) }
    taint_symbol_0 = ALIGN(0x8);
    . = taint_symbol_0;
    .taint_symbol_0 : { *(.taint_symbol_0) }

    }
