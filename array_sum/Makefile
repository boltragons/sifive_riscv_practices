TOOLCHAIN := riscv64-unknown-elf
AS := $(TOOLCHAIN)-as
AS_FLAGS := -march=rv32imc -g
LD := $(TOOLCHAIN)-ld
LD_FLAGS := -T src/memory.lds -m elf32lriscv

all: obj/start.o obj/main.o
	@$(LD) $(LD_FLAGS) obj/start.o obj/main.o -o bin/app.elf 

obj/start.o: src/start.s
	@$(AS) $(AS_FLAGS) src/start.s -o obj/start.o

obj/main.o: src/main.s
	@$(AS) $(AS_FLAGS) src/main.s -o obj/main.o

clean:
	@rm -rf obj/* bin/*
