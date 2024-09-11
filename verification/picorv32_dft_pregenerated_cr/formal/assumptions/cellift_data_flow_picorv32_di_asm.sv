asm_di_mem_ready: assume property (mem_ready == 1'b1); // Didn't work in simulation, because our mem has 1 cycle delay

// asm_di_mem_valid_ready: assume property(mem_valid |-> mem_ready);
// asm_di_not_mem_valid_ready: assume property(!mem_valid |-> !mem_ready);