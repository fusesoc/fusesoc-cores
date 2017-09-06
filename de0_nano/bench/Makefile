BOOTROM_ADDR ?= 0x80000
RESET_VECTOR ?= 0x100
IMAGE ?= spi_image
IMAGE_NAME ?= $(IMAGE)

all: $(IMAGE).vh

%.vh: %.ub
	or1k-elf-objcopy --change-addresses $(BOOTROM_ADDR) -I binary -O verilog $< $@

%.bin: %.elf
	or1k-elf-objcopy -O binary $< $@

%.ub: %.bin
	mkimage \
	-A or1k \
	-C none \
	-T standalone \
	-a 0x100 \
	-e $(RESET_VECTOR) \
	-n '$@' \
	-d $< \
	$@

%.elf: %.S
	or1k-elf-gcc -nostdlib $< -o $@

clean:
	rm -f $(IMAGE).vh
