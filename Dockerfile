# Copyright 2024 Flavien Solt, Katharina Ceesay-Seitz, ETH Zurich.
# Licensed under the General Public License, Version 3.0, see LICENSE for details.
# SPDX-License-Identifier: GPL-3.0-only

FROM ubuntu@sha256:b5a61709a9a44284d88fb12e5c48db0409cfad5b69d4ff8224077c57302df9cf
RUN apt-get update && apt-get install -y curl gnupg apt-utils && \
    echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list && curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | apt-key add && \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    autoconf automake autotools-dev libmpc-dev libmpfr-dev libgmp-dev gawk build-essential \
    bison flex texinfo gperf libtool patchutils bc zlib1g-dev git perl python3 make g++ libfl2 \
    libfl-dev zlib1g zlib1g-dev git autoconf flex bison gtkwave python3.9 python3.9-venv clang \
    tcl-dev libreadline-dev jq libexpat-dev device-tree-compiler vim && \
    apt-get install -y sbt && \
    apt-get install -y software-properties-common  default-jdk default-jre gengetopt && \
    apt-get install -y patch diffstat texi2html subversion chrpath wget && \
    apt-get install -y libgtk-3-dev gettext && \
    apt-get install -y python3-pip python3.8-dev rsync libguestfs-tools expat ctags && \
    apt-get install -y libexpat1-dev libusb-dev libncurses5-dev cmake gtkwave help2man python3 python3-pip libmpc-dev libmpfr-dev libgmp-dev gawk ninja-build libglib2.0-dev libslirp-dev && \
    apt-get install -y libc6-dev libffi-dev xz-utils gnupg netbase && \
    apt-get install -y libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev libboost-iostreams-dev && \
    apt-get install && add-apt-repository ppa:deadsnakes/ppa && apt-get update -y && apt-get install python3.12 -y

############################
# CellIFT meta and tools
############################

# Not a recursive clone. We will clone the tools separately. You might adapt this to the underlying hardware.
RUN bash -c "git clone https://github.com/comsec-group/cellift-meta.git && echo 'export CELLIFT_JOBS=220' >> /cellift-meta/env.sh"

# sv2v, starting with stack
RUN bash -c "source /cellift-meta/env.sh && wget -qO- https://get.haskellstack.org/ | sh"
RUN git clone https://github.com/zachjs/sv2v.git
RUN bash -c "source /cellift-meta/env.sh && cd /sv2v && make -j 220"


# Rust, Bender, Morty, FuseSoC
RUN bash -c "source /cellift-meta/env.sh && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && cd / && cargo install bender && cargo install morty && pip3 install --upgrade --user fusesoc"
# RISC-v toolchain and spike
# RUN bash -c "source /cellift-meta/env.sh && git clone https://github.com/riscv/riscv-gnu-toolchain && cd riscv-gnu-toolchain/ && ./configure --prefix=/root/prefix-cellift/riscv --with-arch=rv32imc --with-cmodel=medlow --enable-multilib && make -j 220 && cd / && git clone https://github.com/riscv-software-src/riscv-isa-sim.git && source /cellift-meta/env.sh && mkdir -p /riscv-isa-sim/build && cd /riscv-isa-sim/build && ../configure --prefix=/root/prefix-cellift/riscv && make -j 220 && make install"

ENV PATH="/sv2v/bin/:${PATH}"

RUN git clone git@github.com:comsec-group/mucfi.git

RUN cd mucfi

RUN make clean_ysosy && make -j 220 yosys

ENV PATH="/mucfi/mucfi_yosys/:${PATH}"

############################
# Kronos setup
############################

RUN sed -i '/modelsim.mk/d' /kronos/cellift/Makefile
RUN bash -c "source /cellift-meta/env.sh && cd /mucfi/cpus/kronos/cellift/ && make generated/sv2v_out.v"

############################
# PicoRV32 setup
############################



RUN sed -i '/modelsim.mk/d' /picorv32/cellift/Makefile
RUN bash -c "source /cellift-meta/env.sh && cd /mucfi/cpus/picorv32/cellift/ && make generated/sv2v_out.v"

############################
# Scarv setup
############################


# Custom interrupt generator
RUN mkdir -p /cellift-meta/design-processing/common/src
COPY mucfi/custom_irqgen.sv /cellift-meta/design-processing/common/src/custom_irqgen.sv
# Clocked
RUN sed -i '/modelsim.mk/d' /scarv/scarv_clocked/cellift/Makefile
RUN bash -c "source /cellift-meta/env.sh && cd /mucfi/cpus/scarv/scarv_clocked/cellift/ && make generated/sv2v_out.v"
# Unclocked
RUN sed -i '/modelsim.mk/d' /scarv/scarv_unclocked/cellift/Makefile
RUN bash -c "source /cellift-meta/env.sh && cd /mucfi/cpus/scarv/scarv_unclocked/cellift/ && make generated/sv2v_out.v"

############################
# Ibex setup
############################
ENV PATH="/root/.local/bin:${PATH}"


RUN tar -xvzf /ibex.tgz
RUN sed -i '/modelsim.mk/d' /ibex/cellift/Makefile
RUN bash -c "source /cellift-meta/env.sh && cd /mucfi/cpus/ibex/cellift/ && source env.sh && make generated/sv2v_out.v"

