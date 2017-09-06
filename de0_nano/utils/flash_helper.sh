#!/bin/sh

#Create a .jic file that Quartus can write to the de0 nano SPI Flash

#First argument is the .sof file (Altera FPGA image)
#Second argument is binary file (will be placed at address 0x80000 in Flash)

#1. Check arguments
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <sof file> <bin file>" >&2
  exit 1
fi

#2. Copy .sof file here
cp $1 de0_nano.sof

#3. Copy binary here
cp $2 sw.bin

#4. Add uImage header to binary and save to sw.ub
mkimage \
    -A or1k \
    -C none \
    -T standalone \
    -a 0x00000000 \
    -e 0x00000100 \
    -n 'Some fancy software' \
    -d sw.bin \
    sw.ub

#5. Convert to Intel hex
or1k-elf-objcopy -I binary -O ihex sw.ub sw.hex

#6. Create .jic file from de0_nano.sof and sw.hex
quartus_cpf -c de0_nano.cof

#7. Show how to program the image to Flash
echo Done! Run \"quartus_pgm --mode=jtag -o pi\\\;de0_nano.jic\" to program the file to Flash
