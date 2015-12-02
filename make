#!/bin/bash

echo "Compiling bootloader..."
nasm -f bin -o boot.bin boot.asm

echo "Creating [floppy] disk image..."
dd  conv=notrunc if=boot.bin of=boot.flp

