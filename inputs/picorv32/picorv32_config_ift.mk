REGISTER_READ_SIGNALS="cpuregs_rs1,cpuregs_rs2"
REGISTER_WRITE_SIGNALS="cpuregs_wrdata"
REGISTER_FILE="cpuregs"
REGISTER_RS1=
REG_ADDR="decoded_rs1"
INSTR_WORD="mem_rdata_latched"
FORWARDING_INPUT_BEFORE_REGREAD=
FORWARDING_OUTPUTS=
PC_SIGNAL="reg_pc"
CLOCK_SIGNAL=clk
RESET_SIGNAL=resetn
RESET_POLARITY=0
ISA_SELECTION=i,m,zicsr,zifencei
TOP_MODULE=picorv32
DESIGN_DIR=/data/kceesay/workspace/mucfi/cpus/picorv32
YOSYS_DIR=/data/kceesay/workspace/mucfi/mucfi_yosys/
PATH_TO_PY_SCRIPTS=/data/kceesay/workspace/mucfi/automation
OUT_DIR=/data/kceesay/workspace/mucfi/verification/picorv32_ift
TAINT_TRACKING_METHOD=ift
CONFIG_FILE=/data/kceesay/workspace/mucfi/inputs/picorv32/picorv32_config_ift.mk
OPERAND_FILE_TEMPLATE=/data/kceesay/workspace/mucfi/verification/common/templates/signal_defs/operand_assignments_first.sv
FWD_MUX_SELECTS=