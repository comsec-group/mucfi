bit gen_instr_word_sampling_cond;
assign gen_instr_word_sampling_cond = 
 $past(((mem_do_rinst &&
 mem_done)));
;