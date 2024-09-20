// Experiment 1
// no input assumptions (the default case described in the paper)

// Since in Kronos all instructions were able to violate mucfi in the default case, we also examined other integration scenarios of Kronos:

// Experiment 2
// ACK always high violates the pipelined mode of Wishbone. This scenario could happen if Kronos is mistakenly integrated with a classic Wishbone counterpart. Alternatively, it could happen if fault injections on the bus interface occur.
 asm_di_instr_ack_high: assume property(instr_ack);
 asm_di_data_ack_high: assume property(data_ack);


// Experiment 3
// Modelling one good case of the pipelined Wishbone interface
// asm_di_instr_ack: assume property(instr_req |=> instr_ack);
// asm_di_data_ack: assume property(data_req |=> data_ack);

// asm_di_instr_ack2: assume property(##1 instr_ack |-> $past(instr_req));
// asm_di_data_ack2: assume property(data_ack |-> $past(data_req));


