RISCV_PREFIX = riscv32-unknown-elf


RV_ARCH_FLAGS ?= -march=rv32g -mabi=ilp32
RISCV_GCC_OPTS ?= $(RV_ARCH_FLAGS) -static -mcmodel=medany -fvisibility=hidden -DOPENSSL_AES_CONST_TIME -nostdlib -nostartfiles -std=gnu99 -O2 -Wall -Wno-deprecated-declarations
RISCV_OBJDUMP ?= $(RISCV_PREFIX)-objdump -D

CC = $(RISCV_PREFIX)-gcc

build/app.elf: main.S link.ld | build
	$(CC) $< -o $@ -static -mcmodel=medany $(RISCV_GCC_OPTS) -Tlink.ld
	$(RISCV_OBJDUMP) $@ > $@.dump

build:
	mkdir -p build

.PHONY: clean
clean:
	rm -rf build
