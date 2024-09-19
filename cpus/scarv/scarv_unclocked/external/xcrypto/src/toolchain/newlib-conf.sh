#!/bin/bash

source $REPO_HOME/src/toolchain/share.sh

set -e
set -x

export RISCV=$INSTALL_DIR

mkdir -p $INSTALL_DIR

# ------ Newlib ------------------------------------------------------------

refresh_dir  $DIR_NEWLIB_BUILD
cd           $DIR_NEWLIB_BUILD

export PATH="$RISCV/bin:$PATH"

$DIR_NEWLIB/configure \
    --prefix=$INSTALL_DIR \
    --target=$TARGET_ARCH \
    --with-arch=$ARCH_STRING --with-abi=$ABI_STRING

