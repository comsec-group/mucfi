bit gen_uc_rs2;
assign gen_uc_rs2 = $past(((&
{ (| { (u_if__u_rf__reg_vld  &&
 u_ex__regwr_en ), (u_if__instr_vld  &&
 u_if__u_rf__instr_rdy ) }), ({ (u_if__u_rf__reg_rs2  ==  u_ex__regwr_sel ), (u_if__u_rf__reg_vld  &&
 u_ex__regwr_en ), (u_if__instr_vld  &&
 u_if__u_rf__instr_rdy ) } != 3'h2), rstz })));