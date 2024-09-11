# Copyright 2023 Katharina Ceesay-Seitz, ETH Zurich.
# Licensed under the General Public License, Version 3.0, see LICENSE for details.
# SPDX-License-Identifier: GPL-3.0-only

yosys update_condition -read-from-signals ${INSTR_WORD} -signal_name ${REG_ADDR} -verbose