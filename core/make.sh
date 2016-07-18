gcc -std=gnu99 -nostdlib -ffreestanding -m32 -c stage2.c

ld --script linker.ld -static -nostdlib --nmagic -o stage2.bin stage2.o
