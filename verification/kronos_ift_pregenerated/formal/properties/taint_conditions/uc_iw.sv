bit gen_instr_word_sampling_cond;
assign gen_instr_word_sampling_cond =
 $past(((&
{ (u_if__instr_vld  &&
 u_if__u_rf__instr_rdy ), rstz })));
;