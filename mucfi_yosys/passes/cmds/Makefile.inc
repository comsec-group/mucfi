
ifeq ($(DISABLE_SPAWN),0)
OBJS += passes/cmds/exec.o
endif
OBJS += passes/cmds/add.o
OBJS += passes/cmds/delete.o
OBJS += passes/cmds/design.o
OBJS += passes/cmds/select.o
OBJS += passes/cmds/show.o
OBJS += passes/cmds/viz.o
OBJS += passes/cmds/rename.o
OBJS += passes/cmds/autoname.o
OBJS += passes/cmds/connect.o
OBJS += passes/cmds/scatter.o
OBJS += passes/cmds/setundef.o
OBJS += passes/cmds/splitnets.o
OBJS += passes/cmds/splitcells.o
OBJS += passes/cmds/stat.o
OBJS += passes/cmds/setattr.o
OBJS += passes/cmds/copy.o
OBJS += passes/cmds/splice.o
OBJS += passes/cmds/scc.o
OBJS += passes/cmds/pre_cellift.o
OBJS += passes/cmds/stat_pre_cellift.o
OBJS += passes/cmds/stat_shift_offsets.o
OBJS += passes/cmds/breakdown_glift.o
OBJS += passes/cmds/taint_probes.o
OBJS += passes/cmds/mul_to_adds.o
OBJS += passes/cmds/timestamp.o
OBJS += passes/cmds/add_attrs_to_state_elems.o
OBJS += passes/cmds/clear_all_attrs.o
OBJS += passes/cmds/insert_pmux_cell.o
OBJS += passes/cmds/insert_shift_cell.o
OBJS += passes/cmds/insert_shiftx_cell.o
OBJS += passes/cmds/insert_dff_cell.o
OBJS += passes/cmds/list_state_elements.o
OBJS += passes/cmds/pmux_statistics.o
OBJS += passes/cmds/regroup_mux_by_sel.o
OBJS += passes/cmds/torder.o
OBJS += passes/cmds/logcmd.o
OBJS += passes/cmds/tee.o
OBJS += passes/cmds/write_file.o
OBJS += passes/cmds/connwrappers.o
OBJS += passes/cmds/cover.o
OBJS += passes/cmds/trace.o
OBJS += passes/cmds/plugin.o
OBJS += passes/cmds/check.o
OBJS += passes/cmds/qwp.o
OBJS += passes/cmds/edgetypes.o
OBJS += passes/cmds/portlist.o
OBJS += passes/cmds/chformal.o
OBJS += passes/cmds/chtype.o
OBJS += passes/cmds/blackbox.o
OBJS += passes/cmds/ltp.o
ifeq ($(DISABLE_SPAWN),0)
OBJS += passes/cmds/bugpoint.o
endif
OBJS += passes/cmds/scratchpad.o
OBJS += passes/cmds/logger.o
OBJS += passes/cmds/printattrs.o
OBJS += passes/cmds/sta.o
OBJS += passes/cmds/clean_zerowidth.o
OBJS += passes/cmds/xprop.o