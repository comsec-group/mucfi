


regrd_rs1 <= register[rs1];

update_condition_regrd_rs1 =
  update_condition(register[rs1]) || update_condition(rs1);


if (rs1 == 0)
  regrd_rs1 <= '0;
else if (regrd_en && rs1 == regwr_sel)
  regrd_rs1 <= regwr_data;
else



