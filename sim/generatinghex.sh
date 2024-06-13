#!/bin/bash

# Set input file
[ ! -z "${1}" ] && infile="${1}" || infile="test.c"

# Architecture and memory settings
ARCH=rv32i
ROM=2048
RAM=25600000
STACK=64

# Compiler and linker flags
# CFLAGS=" -march=$ARCH -mabi=ilp32 --specs=picolibc.specs -Os -g3 -flto -DPICOLIBC_INTEGER_PRINTF_SCANF -Wall"
LDFLAGS="-Wl,--gc-sections,--defsym=__flash=0x00000000,--defsym=__flash_size=$ROM,--defsym=__ram=0x02000000,--defsym=__stack_size=$STACK,--defsym=__ram_size=$RAM -Tpicolibc.ld"

# Change directory if necessary
cd ../

# Compile the source file
riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 --specs=picolibc.specs -Os -g3 -flto -DPICOLIBC_INTEGER_PRINTF_SCANF -Wall -c sim/$infile -o temp.file.o

# Check if compilation was successful
if [ $? -ne 0 ]; then
  echo "Compilation failed."
fi

# Link the object file
riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 $LDFLAGS -o temp.file.elf temp.file.o

# Check if linking was successful
if [ $? -ne 0 ]; then
  echo "Linking failed."
fi

# Generate the machine code listing
riscv64-unknown-elf-objdump --visualize-jumps -t -S --source-comment='     ### ' temp.file.elf -M no-aliases,numeric > machine_code.lss

# Generate the binary file
riscv64-unknown-elf-objcopy -O binary temp.file.elf temp.file.bin

# Truncate the binary file to the ROM size
truncate -s $ROM temp.file.bin

# Generate the Verilog hex file
riscv64-unknown-elf-objcopy --verilog-data-width=4 --reverse-bytes=4 -I binary -O verilog temp.file.bin program_dump.hex

# Show the size of the binary
riscv64-unknown-elf-size -B --common temp.file.elf

# Check if all steps were successful
if [ $? -eq 0 ]; then
  echo "program_dump.hex and machine_code.lss have been successfully generated from $infile"
else
  echo "$infile could not be converted into binary format. :("
fi

# Clean up temporary files
rm -f temp.file.*
