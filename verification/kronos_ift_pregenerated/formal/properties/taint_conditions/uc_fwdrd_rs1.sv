bit gen_fwdrd_rs1;
assign gen_fwdrd_rs1 = 
 $past((((&
{ (| { (u_if__u_rf__reg_vld  &&
 u_ex__regwr_en ), (u_if__instr_vld  &&
 u_if__u_rf__instr_rdy ) }), ({ (u_if__u_rf__reg_rs1  ==  u_ex__regwr_sel ), (u_if__u_rf__reg_vld  &&
 u_ex__regwr_en ), (u_if__instr_vld  &&
 u_if__u_rf__instr_rdy ) } != 3'h2), rstz }) &
(((u_if__instr_vld  &&
 u_if__u_rf__instr_rdy ) &
((~ (!  u_if__next_instr [19:15])) &
(u_ex__regwr_en  &&
 (u_if__next_instr [19:15] ==  u_ex__regwr_sel )))) | ((~ (u_if__instr_vld  &&
 u_if__u_rf__instr_rdy )) &
((u_if__u_rf__reg_vld  &&
 u_ex__regwr_en ) &
(u_if__u_rf__reg_rs1  ==  u_ex__regwr_sel )))))));
;